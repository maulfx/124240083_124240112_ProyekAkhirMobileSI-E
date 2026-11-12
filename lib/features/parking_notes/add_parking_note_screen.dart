import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/notification_service.dart';
import 'models/parking_note.dart';

class AddParkingNoteScreen extends StatefulWidget {
  final int? noteIndex;
  final String? initialLocation;
  final String? initialSlot;

  const AddParkingNoteScreen({
    super.key,
    this.noteIndex,
    this.initialLocation,
    this.initialSlot,
  });

  @override
  State<AddParkingNoteScreen> createState() => _AddParkingNoteScreenState();
}

class _AddParkingNoteScreenState extends State<AddParkingNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _locationController;
  late final TextEditingController _slotController;
  late final TextEditingController _noteController;

  bool _isEditMode = false;
  DateTime? _reminderDateTime;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.noteIndex != null;

    _locationController = TextEditingController(text: widget.initialLocation ?? '');
    _slotController = TextEditingController(text: widget.initialSlot ?? '');
    _noteController = TextEditingController();

    if (_isEditMode) {
      final box = Hive.box('parking_notes');
      final raw = box.getAt(widget.noteIndex!);
      if (raw is Map) {
        final note = ParkingNote.fromMap(raw);
        _locationController.text = note.locationName;
        _slotController.text = note.slotNumber;
        _noteController.text = note.note;
        _reminderDateTime = note.reminderTime;
      }
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _slotController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickReminderDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderDateTime ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reminderDateTime ?? now.add(const Duration(minutes: 30))),
    );

    if (pickedTime == null || !mounted) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (combined.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Waktu pengingat harus berada di masa mendatang')),
      );
      return;
    }

    setState(() {
      _reminderDateTime = combined;
    });
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final box = Hive.box('parking_notes');
    final note = ParkingNote(
      locationName: _locationController.text.trim(),
      slotNumber: _slotController.text.trim(),
      note: _noteController.text.trim(),
      createdAt: DateTime.now(),
      reminderTime: _reminderDateTime,
    );

    if (_isEditMode) {
      await box.putAt(widget.noteIndex!, note.toMap());
    } else {
      await box.add(note.toMap());
    }

    if (_reminderDateTime != null) {
      final notifId = widget.noteIndex ?? (box.length - 1);
      await NotificationService().scheduleNotification(
        id: notifId.abs() % 10000 + 100,
        title: '⏰ Pengingat Parkir: ${_locationController.text.trim()}',
        body: 'Slot: ${_slotController.text.trim()} — Cek kendaraan atau ketersediaan parkir Anda.',
        scheduledDate: _reminderDateTime!,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditMode ? 'Catatan parkir diperbarui!' : 'Catatan parkir disimpan di Hive!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF9FAFB);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textMain = isDark ? Colors.white : const Color(0xFF111827);
    final textMuted = isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Catatan Parkir' : 'Catatan Parkir Baru',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: cardBg,
        foregroundColor: textMain,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Simpan detail slot parkir Anda di database lokal (Hive) agar mudah dicek kembali kapan saja tanpa koneksi internet.',
                style: GoogleFonts.plusJakartaSans(color: textMuted, fontSize: 13),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Nama Tempat / Lokasi Parkir *',
                  hintText: 'Misal: Pakuwon Mall Jogja',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Nama lokasi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _slotController,
                decoration: InputDecoration(
                  labelText: 'Nomor Slot / Kolom Parkir *',
                  hintText: 'Misal: B1 - Slot 24 / Tiang G10',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.local_parking_outlined),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Nomor slot tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Catatan Tambahan (Opsional)',
                  hintText: 'Misal: Dekat lift barang, pintu keluar timur',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pengingat Notifikasi (Modul 7 Scheduled)',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15, color: textMain),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withAlpha(50)),
                ),
                child: Row(
                  children: [
                    Icon(
                      _reminderDateTime != null ? Icons.alarm_on : Icons.alarm,
                      color: _reminderDateTime != null ? const Color(0xFF3B82F6) : textMuted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _reminderDateTime != null
                                ? 'Pengingat Aktif'
                                : 'Belum ada pengingat',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 14, color: textMain),
                          ),
                          Text(
                            _reminderDateTime != null
                                ? '${_reminderDateTime!.day}/${_reminderDateTime!.month}/${_reminderDateTime!.year} - ${_reminderDateTime!.hour.toString().padLeft(2, '0')}:${_reminderDateTime!.minute.toString().padLeft(2, '0')}'
                                : 'Pilih waktu pengingat parkir',
                            style: GoogleFonts.plusJakartaSans(color: textMuted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _pickReminderDateTime,
                      child: Text(_reminderDateTime != null ? 'Ubah' : 'Set Waktu'),
                    ),
                    if (_reminderDateTime != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20, color: Colors.redAccent),
                        onPressed: () => setState(() => _reminderDateTime = null),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    _isEditMode ? 'Perbarui Catatan' : 'Simpan Catatan',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

