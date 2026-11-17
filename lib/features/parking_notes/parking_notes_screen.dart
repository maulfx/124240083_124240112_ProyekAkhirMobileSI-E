import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_dock_navigation.dart';
import 'models/parking_note.dart';
import 'add_parking_note_screen.dart';

class ParkingNotesScreen extends StatelessWidget {
  const ParkingNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    final bg = AppColors.background;
    final cardBg = AppColors.surfaceCard;
    final textMain = AppColors.textPrimary;
    final textMuted = AppColors.textMuted;

    final box = Hive.box('parking_notes');

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
                body: 'Notifikasi instan lokal berhasil dipicu!',
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
          ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box box, _) {
              if (box.isEmpty) {
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
                          'Catat lokasi dan nomor slot tempat Anda memarkir kendaraan secara lokal di Hive (dapat diakses offline).',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: textMuted),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddParkingNoteScreen()),
                            );
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

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 110),
            itemCount: box.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final raw = box.getAt(index);
              if (raw is! Map) return const SizedBox.shrink();
              final note = ParkingNote.fromMap(raw);

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
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: textMuted),
                          onSelected: (val) {
                            if (val == 'edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddParkingNoteScreen(noteIndex: index),
                                ),
                              );
                            } else if (val == 'delete') {
                              final notifId = index.abs() % 10000 + 100;
                              NotificationService().cancelNotification(notifId);
                              box.deleteAt(index);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Catatan dihapus dari Hive')),
                              );
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddParkingNoteScreen()),
            );
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

