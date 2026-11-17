import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/session_service.dart';
import '../../profile/backend/profile_backend.dart';
import '../models/parking_note.dart';

class ParkingNotesBackend extends ChangeNotifier {
  ParkingNotesBackend._();
  static final ParkingNotesBackend instance = ParkingNotesBackend._();

  SupabaseClient get _client => Supabase.instance.client;
  Box get _box => Hive.box('parking_notes');

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSyncedWithCloud = false;
  bool get isSyncedWithCloud => _isSyncedWithCloud;

  List<ParkingNote> _notes = [];
  List<ParkingNote> get notes => _notes;

  int get totalNotesCount => _notes.length;

  int get activeRemindersCount {
    final now = DateTime.now();
    return _notes.where((n) => n.reminderTime != null && n.reminderTime!.isAfter(now)).length;
  }

  /// Memuat catatan dari Supabase (dengan fallback instan ke Hive jika offline / tabel belum dibuat)
  Future<List<ParkingNote>> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    // 1. Muat dari Hive lokal terlebih dahulu agar UI instan
    _loadFromHive();

    // 2. Coba sinkronisasi dengan Supabase
    try {
      final uid = SessionService.instance.userId ?? ProfileBackend.instance.userId;

      dynamic query = _client.from('parking_notes').select();
      if (uid.isNotEmpty) {
        query = query.or('user_id.eq.$uid,user_id.is.null');
      }

      final response = await query.order('created_at', ascending: false);
      final List<dynamic> data = response as List<dynamic>;

      final cloudNotes = <ParkingNote>[];
      for (final item in data) {
        if (item is Map) {
          cloudNotes.add(ParkingNote.fromMap(item));
        }
      }

      // Update Hive agar sinkron dengan Cloud
      await _box.clear();
      for (final note in cloudNotes) {
        await _box.add(note.toMap());
      }

      _notes = cloudNotes;
      _isSyncedWithCloud = true;
    } catch (e) {
      debugPrint('[ParkingNotesBackend] Menggunakan data offline Hive (Supabase: $e)');
      _isSyncedWithCloud = false;
      _loadFromHive();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _notes;
  }

  void _loadFromHive() {
    final list = <ParkingNote>[];
    for (int i = 0; i < _box.length; i++) {
      final raw = _box.getAt(i);
      if (raw is Map) {
        list.add(ParkingNote.fromMap(raw));
      }
    }
    _notes = list;
  }

  /// Menyimpan atau memperbarui catatan parkir (Supabase + Hive)
  Future<bool> saveNote({
    required String locationName,
    required String slotNumber,
    required String noteText,
    DateTime? reminderTime,
    int? editIndex,
    String? existingId,
  }) async {
    final uid = SessionService.instance.userId ?? ProfileBackend.instance.userId;

    final note = ParkingNote(
      id: existingId,
      userId: uid.isNotEmpty ? uid : null,
      locationName: locationName,
      slotNumber: slotNumber,
      note: noteText,
      createdAt: DateTime.now(),
      reminderTime: reminderTime,
    );

    // 1. Simpan di Supabase jika memungkinkan
    String? assignedId = existingId;
    try {
      final payload = note.toSupabaseMap();
      if (existingId != null && existingId.isNotEmpty) {
        final res = await _client.from('parking_notes').update(payload).eq('id', existingId).select();
        if (res.isNotEmpty) {
          assignedId = res.first['id']?.toString() ?? assignedId;
        }
      } else {
        final res = await _client.from('parking_notes').insert(payload).select();
        if (res.isNotEmpty) {
          assignedId = res.first['id']?.toString();
        }
      }
      _isSyncedWithCloud = true;
    } catch (e) {
      debugPrint('[ParkingNotesBackend] Supabase insert/update note error: $e');
      _isSyncedWithCloud = false;
    }

    // 2. Simpan di Hive Box lokal
    final savedNote = ParkingNote(
      id: assignedId,
      userId: note.userId,
      locationName: note.locationName,
      slotNumber: note.slotNumber,
      note: note.note,
      createdAt: note.createdAt,
      reminderTime: note.reminderTime,
    );

    if (editIndex != null && editIndex >= 0 && editIndex < _box.length) {
      await _box.putAt(editIndex, savedNote.toMap());
    } else {
      await _box.add(savedNote.toMap());
    }

    _loadFromHive();
    notifyListeners();
    return _isSyncedWithCloud;
  }

  /// Menghapus catatan parkir (Supabase + Hive)
  Future<void> deleteNote(int index) async {
    if (index < 0 || index >= _notes.length) return;
    final note = _notes[index];

    // 1. Hapus dari Supabase jika ada id
    if (note.id != null && note.id!.isNotEmpty) {
      try {
        await _client.from('parking_notes').delete().eq('id', note.id!);
      } catch (e) {
        debugPrint('[ParkingNotesBackend] Supabase delete note error: $e');
      }
    }

    // 2. Hapus dari Hive
    if (index < _box.length) {
      await _box.deleteAt(index);
    }

    _loadFromHive();
    notifyListeners();
  }
}
