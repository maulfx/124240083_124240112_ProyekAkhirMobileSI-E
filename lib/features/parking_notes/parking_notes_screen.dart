import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_dock_navigation.dart';
import '../profile/backend/profile_backend.dart';
import 'backend/parking_notes_backend.dart';
import 'add_parking_note_screen.dart';

class ParkingNotesScreen extends StatefulWidget {
  const ParkingNotesScreen({super.key});

  @override
  State<ParkingNotesScreen> createState() => _ParkingNotesScreenState();
}

class _ParkingNotesScreenState extends State<ParkingNotesScreen> {
  @override
  void initState() {
    super.initState();
    ParkingNotesBackend.instance.loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    final bg = AppColors.background;
    final cardBg = AppColors.surfaceCard;
    final textMain = AppColors.textPrimary;
    final textMuted = AppColors.textMuted;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'Catatan & Pengingat Parkir',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: cardBg,
        foregroundColor: textMain,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Tes Notifikasi Instan',
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () async {
              await NotificationService().showInstantNotification(
                id: 888,
                title: '🔔 Tes Notifikasi ParkSmart',
                body: 'Notifikasi instan lokal (Modul 7) berhasil dipicu!',
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Notifikasi instan dikirim ke status bar!'),
                    backgroundColor: AppColors.notes.primaryBlue,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListenableBuilder(
            listenable: ParkingNotesBackend.instance,
            builder: (context, _) {
              final backend = ParkingNotesBackend.instance;
              final notes = backend.notes;

              if (backend.isLoading && notes.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (notes.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 32, 32, 110),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.note_alt_outlined, size: 64, color: textMuted.withAlpha(120)),
                        const SizedBox(height: 16),
                        Text(
                          'Belum Ada Catatan Parkir',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: textMain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Catat lokasi dan nomor slot tempat Anda memarkir kendaraan. Tersimpan aman di Supabase dan Hive.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textMuted),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddParkingNoteScreen()),
                            );
                            await backend.loadNotes();
                            await ProfileBackend.instance.refreshNotesStats();
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Buat Catatan Baru'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.notes.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await backend.loadNotes();
                  await ProfileBackend.instance.refreshNotesStats();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 150),
                  itemCount: notes.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    // Header status sinkronisasi
                    if (index == 0) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: backend.isSyncedWithCloud
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: backend.isSyncedWithCloud
                                ? Colors.green.withValues(alpha: 0.3)
                                : Colors.blue.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              backend.isSyncedWithCloud ? Icons.cloud_done : Icons.cloud_queue,
                              size: 18,
                              color: backend.isSyncedWithCloud ? Colors.green : Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                backend.isSyncedWithCloud
                                    ? 'Tersinkronisasi dengan Database Supabase & Hive'
                                    : 'Tersimpan Lokal di Hive (Offline)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: backend.isSyncedWithCloud ? Colors.green.shade800 : Colors.blue.shade800,
                                ),
                              ),
                            ),
                            Text(
                              '${notes.length} Catatan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textMain,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final noteIndex = index - 1;
                    final note = notes[noteIndex];

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withAlpha(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDark ? 30 : 10),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.notes.primaryBlue.withAlpha(30),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.local_parking, color: AppColors.notes.primaryBlue, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      note.locationName,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: textMain,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.notes.activeStatusBg,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            'Slot: ${note.slotNumber}',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: AppColors.notes.activeStatusText,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        if (note.isSynced)
                                          Icon(Icons.cloud_done, size: 14, color: Colors.green.shade600)
                                        else
                                          Tooltip(
                                            message: 'Tersimpan lokal di Hive (otomatis sync saat online)',
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.cloud_off, size: 14, color: Colors.orange.shade700),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Offline',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.orange.shade700,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: textMuted),
                                onSelected: (val) async {
                                  if (val == 'edit') {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddParkingNoteScreen(
                                          noteIndex: noteIndex,
                                          note: note,
                                        ),
                                      ),
                                    );
                                    await backend.loadNotes();
                                    await ProfileBackend.instance.refreshNotesStats();
                                  } else if (val == 'delete') {
                                    final notifId = (note.id != null ? note.id!.hashCode : noteIndex).abs() % 10000 + 100;
                                    NotificationService().cancelNotification(notifId);
                                    await backend.deleteNote(note);
                                    await ProfileBackend.instance.refreshNotesStats();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Catatan dihapus dari Supabase & Hive')),
                                      );
                                    }
                                  }
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 18),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 18, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Hapus', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (note.note.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              note.note,
                              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textMain),
                            ),
                          ],
                          if (note.reminderTime != null) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.alarm, size: 16, color: AppColors.notes.alarmWarning),
                                const SizedBox(width: 6),
                                Text(
                                  'Pengingat: ${note.reminderTime!.day}/${note.reminderTime!.month} ${note.reminderTime!.hour.toString().padLeft(2, '0')}:${note.reminderTime!.minute.toString().padLeft(2, '0')}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.notes.alarmWarning,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: math.max(MediaQuery.of(context).padding.bottom + 12, 24),
            left: 20,
            right: 20,
            child: const Center(
              child: BottomDockNavigation(activeTab: DockTab.notes),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 76),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddParkingNoteScreen()),
            );
            await ParkingNotesBackend.instance.loadNotes();
            await ProfileBackend.instance.refreshNotesStats();
          },
          backgroundColor: AppColors.notes.primaryBlue,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Catat Parkir'),
        ),
      ),
    );
  }
}
