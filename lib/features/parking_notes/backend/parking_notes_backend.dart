import 'dart:math';
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

  static const String _kPendingDeletionsKey = '__ps_pending_deleted_notes__';

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

  /// Menghasilkan RFC 4122 Version 4 UUID kriptografis untuk primary key offline
  String _generateUuid() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40; // Version 4
    values[8] = (values[8] & 0x3f) | 0x80; // Variant 10
    final hex = values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  /// Mendapatkan daftar ID catatan yang tertunda dihapus dari Supabase
  List<String> _getPendingDeletions() {
    final raw = _box.get(_kPendingDeletionsKey);
    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }
    return [];
  }

  Future<void> _recordPendingDelete(String id) async {
    final list = _getPendingDeletions();
    if (!list.contains(id)) {
      list.add(id);
      await _box.put(_kPendingDeletionsKey, list);
    }
  }

  Future<void> _removePendingDelete(String id) async {
    final list = _getPendingDeletions();
    if (list.remove(id)) {
      await _box.put(_kPendingDeletionsKey, list);
    }
  }

  /// Memuat catatan dari Hive lokal dengan isolasi ID pengguna aktif
  void _loadFromHive() {
    final currentUid = SessionService.instance.userId ?? ProfileBackend.instance.userId;
    final list = <ParkingNote>[];
    final pendingDeletions = _getPendingDeletions().toSet();
    final keysToMigrate = <dynamic, ParkingNote>{};

    for (final key in _box.keys) {
      if (key == _kPendingDeletionsKey) continue;
      final raw = _box.get(key);
      if (raw is Map) {
        final note = ParkingNote.fromMap(raw);
        if (note.id != null && pendingDeletions.contains(note.id)) {
          continue; // Sedang menunggu penghapusan di cloud
        }

        // Migrasi jika key Hive lama masih bertipe integer atau note belum punya ID
        if (key is! String || note.id == null || note.id!.isEmpty) {
          final assignedId = (note.id != null && note.id!.isNotEmpty) ? note.id! : _generateUuid();
          final migratedNote = note.copyWith(id: assignedId);
          keysToMigrate[key] = migratedNote;
        }

        // Isolasi data multi-user:
        // Tampilkan catatan milik user saat ini, atau catatan anonim jika belum login
        if (currentUid.isNotEmpty) {
          if (note.userId == null || note.userId!.isEmpty || note.userId == currentUid) {
            list.add(note);
          }
        } else {
          if (note.userId == null || note.userId!.isEmpty) {
            list.add(note);
          }
        }
      }
    }

    // Eksekusi migrasi key lama secara aman
    for (final entry in keysToMigrate.entries) {
      _box.delete(entry.key);
      _box.put(entry.value.id!, entry.value.toMap());
    }

    // Urutkan berdasarkan created_at descending (terbaru di atas)
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _notes = list;
  }

  /// Sinkronisasi dua arah yang tangguh (Offline-First):
  /// 1. Tampilkan data Hive lokal secara instan (0 latency)
  /// 2. Flush antrean penghapusan offline ke Supabase
  /// 3. Push catatan offline lokal yang belum tersinkron (isSynced == false) ke Supabase
  /// 4. Pull data terbaru dari Supabase & merge ke Hive tanpa menghapus data offline yang belum terkirim
  Future<List<ParkingNote>> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    // 1. Tampilkan data dari Hive lokal agar UI langsung responsif
    _loadFromHive();
    _isLoading = false;
    notifyListeners();

    // 2. Sinkronisasi dengan Supabase jika terhubung ke internet
    try {
      final currentUid = SessionService.instance.userId ?? ProfileBackend.instance.userId;

      // 2a. Flush pending deletions ke Supabase
      final pendingDeletes = _getPendingDeletions();
      for (final delId in pendingDeletes) {
        try {
          await _client.from('parking_notes').delete().eq('id', delId);
          await _removePendingDelete(delId);
        } catch (_) {
          // Tetap simpan di pending jika koneksi bermasalah
        }
      }

      // 2b. Push catatan lokal yang belum pernah terkirim ke Supabase
      final unsynced = _notes.where((n) => !n.isSynced && n.id != null).toList();
      for (final unsyncedNote in unsynced) {
        try {
          final payload = unsyncedNote.toSupabaseMap();
          await _client.from('parking_notes').upsert(payload);
          final updated = unsyncedNote.copyWith(isSynced: true);
          await _box.put(updated.id!, updated.toMap());
        } catch (e) {
          debugPrint('[ParkingNotesBackend] Menunggu online untuk push catatan: $e');
        }
      }

      // 2c. Pull data dari Supabase
      dynamic query = _client.from('parking_notes').select();
      if (currentUid.isNotEmpty) {
        query = query.or('user_id.eq.$currentUid,user_id.is.null');
      }

      final response = await query.order('created_at', ascending: false);
      final List<dynamic> data = response as List<dynamic>;

      final cloudIds = <String>{};
      for (final item in data) {
        if (item is Map) {
          final cloudNote = ParkingNote.fromMap(item).copyWith(isSynced: true);
          if (cloudNote.id != null && cloudNote.id!.isNotEmpty) {
            cloudIds.add(cloudNote.id!);
            await _box.put(cloudNote.id!, cloudNote.toMap());
          }
        }
      }

      // 2d. Bersihkan data lokal yang statusnya synced di cloud tapi sudah dihapus dari server
      // Catatan lokal offline (isSynced == false) TIDAK AKAN PERNAH dihapus!
      for (final key in _box.keys) {
        if (key == _kPendingDeletionsKey) continue;
        final raw = _box.get(key);
        if (raw is Map) {
          final note = ParkingNote.fromMap(raw);
          final matchesUser = currentUid.isEmpty
              ? (note.userId == null || note.userId!.isEmpty)
              : (note.userId == null || note.userId!.isEmpty || note.userId == currentUid);

          if (matchesUser && note.isSynced && note.id != null && !cloudIds.contains(note.id)) {
            await _box.delete(key);
          }
        }
      }

      _loadFromHive();
      _isSyncedWithCloud = true;
    } catch (e) {
      debugPrint('[ParkingNotesBackend] Mode offline aktif (Supabase error/offline: $e)');
      _isSyncedWithCloud = false;
      _loadFromHive();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _notes;
  }

  /// Menyimpan atau memperbarui catatan parkir dengan penanganan offline otomatis
  Future<bool> saveNote({
    required String locationName,
    required String slotNumber,
    required String noteText,
    DateTime? reminderTime,
    int? editIndex,
    String? existingId,
  }) async {
    final uid = SessionService.instance.userId ?? ProfileBackend.instance.userId;
    final noteId = (existingId != null && existingId.isNotEmpty) ? existingId : _generateUuid();

    final note = ParkingNote(
      id: noteId,
      userId: uid.isNotEmpty ? uid : null,
      locationName: locationName,
      slotNumber: slotNumber,
      note: noteText,
      createdAt: DateTime.now(),
      reminderTime: reminderTime,
      isSynced: false,
    );

    // 1. Simpan di Hive lokal terlebih dahulu agar data tidak pernah hilang
    await _box.put(noteId, note.toMap());
    _loadFromHive();
    notifyListeners();

    // 2. Coba kirimkan ke Supabase
    bool synced = false;
    try {
      final payload = note.toSupabaseMap();
      final res = await _client.from('parking_notes').upsert(payload).select();
      if (res.isNotEmpty) {
        synced = true;
        _isSyncedWithCloud = true;
        final syncedNote = note.copyWith(isSynced: true);
        await _box.put(noteId, syncedNote.toMap());
        _loadFromHive();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[ParkingNotesBackend] Supabase upsert note error (disimpan aman di Hive): $e');
      _isSyncedWithCloud = false;
      synced = false;
    }

    return synced;
  }

  /// Menghapus catatan parkir (Supabase + Hive + antrean jika offline)
  Future<void> deleteNote(dynamic target) async {
    String? targetId;
    int? targetIndex;

    if (target is ParkingNote) {
      targetId = target.id;
    } else if (target is String) {
      targetId = target;
    } else if (target is int) {
      targetIndex = target;
      if (target >= 0 && target < _notes.length) {
        targetId = _notes[target].id;
      }
    }

    if (targetId == null || targetId.isEmpty) {
      if (targetIndex != null && targetIndex >= 0 && targetIndex < _notes.length) {
        _notes.removeAt(targetIndex);
        if (targetIndex < _box.length) {
          await _box.deleteAt(targetIndex);
        }
        notifyListeners();
      }
      return;
    }

    // 1. Coba hapus dari Supabase
    try {
      await _client.from('parking_notes').delete().eq('id', targetId);
      await _removePendingDelete(targetId);
    } catch (e) {
      debugPrint('[ParkingNotesBackend] Gagal hapus di Supabase, dimasukkan ke antrean pending: $e');
      await _recordPendingDelete(targetId);
    }

    // 2. Hapus dari Box Hive lokal
    await _box.delete(targetId);

    // Hapus juga jika ada key peninggalan legacy
    for (final key in _box.keys) {
      if (key == _kPendingDeletionsKey) continue;
      final raw = _box.get(key);
      if (raw is Map && raw['id'] == targetId) {
        await _box.delete(key);
      }
    }

    _loadFromHive();
    notifyListeners();
  }

  /// Membersihkan state memori catatan saat logout pengguna
  void clearUserData() {
    _notes = [];
    _isSyncedWithCloud = false;
    notifyListeners();
  }
}
