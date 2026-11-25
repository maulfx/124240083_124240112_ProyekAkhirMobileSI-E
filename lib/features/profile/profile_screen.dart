import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../widgets/bottom_dock_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/currency_service.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/notification_service.dart';
import '../auth/login_screen.dart' as auth;
import 'settings_screen.dart' as settings;

import '../../core/services/session_service.dart';
import '../../core/services/language_service.dart';
import '../../theme/app_colors.dart';
import '../../core/services/parking_notification_service.dart';
import '../parking_notes/parking_notes_screen.dart';
import 'edit_profile_screen.dart' as edit_profile;
import 'backend/profile_backend.dart';
import '../../core/services/app_image_cache_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _saranController;
  late final TextEditingController _pesanController;
  bool _isSavingKuliahFeedback = false;
  bool _isEditingKuliahFeedback = false;

  @override
  void initState() {
    super.initState();
    _saranController = TextEditingController();
    _pesanController = TextEditingController();
    ProfileBackend.instance.fetchProfile().then((_) {
      if (mounted) {
        if (_saranController.text.isEmpty) {
          _saranController.text = ProfileBackend.instance.saranKuliah;
        }
        if (_pesanController.text.isEmpty) {
          _pesanController.text = ProfileBackend.instance.pesanKuliah;
        }
      }
    });
  }

  @override
  void dispose() {
    _saranController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  Widget _buildMemberBadge(String tier, {required String memberCode}) {
    return _ShimmerMemberBadge(tier: tier);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        ThemeService.instance,
        ProfileBackend.instance,
        LanguageService.instance,
        CurrencyService.instance,
      ]),
      builder: (context, _) {
        final theme = ThemeService.instance;
        final profile = ProfileBackend.instance;
        return Scaffold(
          backgroundColor: theme.bg,
      body: Stack(
        children: [
          SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: ThemeService.instance.border.withValues(alpha: 0.3))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profil Pengguna'.tr, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.bold, color: ThemeService.instance.textPrimary, letterSpacing: -0.5)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const settings.SettingsScreen()));
                    },
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: ThemeService.instance.card, shape: BoxShape.circle, border: Border.all(color: ThemeService.instance.border.withValues(alpha: 0.7)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2))]),
                      child: Icon(Icons.settings, size: 20, color: ThemeService.instance.iconColor),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                children: [
                  // Profile Card
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => edit_profile.EditProfileScreen(
                          initialName: profile.name,
                          initialEmail: profile.email,
                          initialPhone: profile.phone,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: ThemeService.instance.card, borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: ThemeService.instance.border.withValues(alpha: 0.6)),
                        boxShadow: [BoxShadow(color: ThemeService.instance.isDarkMode ? Colors.black.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 96, height: 96,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: ThemeService.instance.chipBg, shape: BoxShape.circle, border: Border.all(color: ThemeService.instance.border.withValues(alpha: 0.8))),
                            child: (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
                                ? CircleAvatar(
                                    backgroundImage: AppImageCacheService.instance.provider(profile.avatarUrl!),
                                  )
                                : CircleAvatar(
                                    backgroundColor: AppColors.primary,
                                    child: Text(
                                      profile.name.trim().isNotEmpty ? profile.name.trim()[0].toUpperCase() : 'J',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Text(profile.name, style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold, color: ThemeService.instance.textPrimary)),
                          const SizedBox(height: 4),
                          Text('${profile.email}\n${profile.phone}', textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: ThemeService.instance.textSecondary, height: 1.5)),
                          const SizedBox(height: 16),
                          _buildMemberBadge(profile.memberTier, memberCode: profile.memberHashCode),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Stats: Total Catatan & Pengingat Aktif (Supabase Cloud + Hive Local)
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ParkingNotesScreen()),
                      );
                      ProfileBackend.instance.refreshNotesStats();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: ThemeService.instance.card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: ThemeService.instance.border.withValues(alpha: 0.7)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('TOTAL CATATAN'.tr, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w500, color: ThemeService.instance.textSecondary, letterSpacing: 0.5)),
                                const SizedBox(height: 2),
                                Text('${profile.totalNotes} Catatan'.tr, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: ThemeService.instance.textPrimary)),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 40, color: ThemeService.instance.divider),
                          Expanded(
                            child: Column(
                              children: [
                                Text('PENGINGAT AKTIF'.tr, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w500, color: ThemeService.instance.textSecondary, letterSpacing: 0.5)),
                                const SizedBox(height: 2),
                                Text('${profile.activeReminders} Pengingat'.tr, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.notes.primaryBlue)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Menu Items
                  // Menu Pilih Bahasa
                  _MenuItem(
                    icon: Icons.language,
                    subtitle: 'BAHASA'.tr,
                    title: LanguageService.instance.isEnglish ? 'English (US/UK)' : 'Bahasa Indonesia',
                    onTap: () => LanguageService.showLanguageSelectionModal(context),
                  ),
                  const SizedBox(height: 12),

                  // Menu Catatan Parkir (Modul 6 - Hive Offline Storage)
                  _MenuItem(
                    icon: Icons.note_alt_outlined,
                    subtitle: 'OFFLINE HIVE STORAGE'.tr,
                    title: 'Catatan & Pengingat Parkir'.tr,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ParkingNotesScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _MenuItem(
                    icon: Icons.notifications_active, subtitle: 'DEVELOPER OPTIONS', title: 'Test Notification',
                    onTap: () {
                      _showNotificationTestMenu(context);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Input & Tampilan Saran & Pesan Kuliah Pemrograman Aplikasi Mobile
                  _buildKuliahFeedbackSection(theme, profile, theme.isDarkMode),
                  const SizedBox(height: 24),

                  // Logout
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: TextButton(
                      onPressed: () {
                        SessionService.instance.clearSession();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const auth.LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.profile.logoutRed,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, size: 18, color: Colors.white),
                          const SizedBox(width: 8),
                          Text('KELUAR DARI AKUN'.tr, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.0)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: math.max(MediaQuery.of(context).padding.bottom + 12, 24) + 76),
                ],
              ),
            ),
          ],
        ),
      ),
          // ─── Dark floating dock navigation (fixed bottom with safe area) ────────
          Positioned(
            bottom: math.max(MediaQuery.of(context).padding.bottom + 12, 24),
            left: 20,
            right: 20,
            child: Center(
              child: const BottomDockNavigation(activeTab: DockTab.profile),
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildKuliahFeedbackSection(ThemeService theme, ProfileBackend profile, bool isDark) {
    final hasSavedData = profile.saranKuliah.isNotEmpty || profile.pesanKuliah.isNotEmpty;
    final showForm = !hasSavedData || _isEditingKuliahFeedback;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.border.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDim,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.warmBorder,
                  ),
                ),
                child: Icon(
                  Icons.school_rounded,
                  size: 22,
                  color: AppColors.auth.linkBlue,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PEMROGRAMAN APLIKASI MOBILE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.auth.linkBlue,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Saran & Pesan Kuliah',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: theme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasSavedData && !showForm)
                IconButton(
                  tooltip: 'Ubah Saran & Pesan',
                  icon: Icon(Icons.edit_note_rounded, color: AppColors.auth.linkBlue, size: 24),
                  onPressed: () {
                    setState(() {
                      _isEditingKuliahFeedback = true;
                      _saranController.text = profile.saranKuliah;
                      _pesanController.text = profile.pesanKuliah;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Display Saved Feedback (if available)
          if (hasSavedData && !showForm) ...[
            if (profile.saranKuliah.isNotEmpty) ...[
              Text(
                'SARAN KULIAH TERSIMPAN',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: theme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.profile.feedbackFieldBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.border.withValues(alpha: 0.6)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb_outline, size: 18, color: AppColors.profile.feedbackIdeaYellow),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        profile.saranKuliah,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          height: 1.5,
                          color: theme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (profile.pesanKuliah.isNotEmpty) ...[
              Text(
                'PESAN KULIAH TERSIMPAN',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: theme.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.profile.feedbackFieldBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.border.withValues(alpha: 0.6)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.profile.feedbackMessageGreen),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        profile.pesanKuliah,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          height: 1.5,
                          color: theme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            // Input Text Fields
            Text(
              'Saran Perkuliahan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _saranController,
              maxLines: 3,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: theme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Tuliskan saran untuk mata kuliah Pemrograman Aplikasi Mobile...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: theme.textSecondary.withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: AppColors.profile.feedbackFieldBg,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.border.withValues(alpha: 0.8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.border.withValues(alpha: 0.8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.profile.feedbackFocusBorder,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            Text(
              'Pesan Perkuliahan',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _pesanController,
              maxLines: 3,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: theme.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Tuliskan pesan atau kesan Anda selama perkuliahan...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: theme.textSecondary.withValues(alpha: 0.6),
                ),
                filled: true,
                fillColor: AppColors.profile.feedbackFieldBg,
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.border.withValues(alpha: 0.8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.border.withValues(alpha: 0.8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.profile.feedbackFocusBorder,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                if (hasSavedData) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isEditingKuliahFeedback = false;
                          _saranController.text = profile.saranKuliah;
                          _pesanController.text = profile.pesanKuliah;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.textSecondary,
                        side: BorderSide(color: theme.border),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Batal',
                        style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _isSavingKuliahFeedback
                        ? null
                        : () async {
                            setState(() => _isSavingKuliahFeedback = true);
                            final success = await ProfileBackend.instance.saveKuliahFeedback(
                              saran: _saranController.text,
                              pesan: _pesanController.text,
                            );
                            if (mounted) {
                              setState(() {
                                _isSavingKuliahFeedback = false;
                                _isEditingKuliahFeedback = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? 'Saran & pesan perkuliahan berhasil disimpan!'
                                        : 'Gagal menyimpan, silakan coba lagi.',
                                  ),
                                  backgroundColor: success ? AppColors.statusSuccess : AppColors.statusError,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                    icon: _isSavingKuliahFeedback
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save_outlined, size: 18),
                    label: Text(
                      _isSavingKuliahFeedback ? 'Menyimpan...' : 'Simpan Saran & Pesan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.profile.feedbackSaveBtn,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}


void _showNotificationTestMenu(BuildContext context) {
  final rootContext = context;
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (sheetContext) => ListenableBuilder(
      listenable: ThemeService.instance,
      builder: (sheetContext, _) {
        final theme = ThemeService.instance;
        final isDark = theme.isDarkMode;
        return Container(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: isDark ? Border(top: BorderSide(color: theme.border)) : null,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.modal.dragHandle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Test Notifications',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceField,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.border),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.notification.urgentBg,
                    child: Icon(Icons.timer_off, color: AppColors.notification.urgentIcon),
                  ),
                  title: Text(
                    'Urgent Action (10 Min Left)',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Simulate overstay warning',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: theme.textSecondary,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: theme.textSecondary),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showSystemUrgentNotification(rootContext);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceField,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.border),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.notification.infoBg,
                    child: Icon(Icons.info_outline, color: AppColors.notification.infoIcon),
                  ),
                  title: Text(
                    'Info Notification (Success)',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Simulate success message',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: theme.textSecondary,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: theme.textSecondary),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showSystemInfoNotification(rootContext);
                  },
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceField,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.border),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.notification.timerBg,
                    child: Icon(Icons.hourglass_bottom_rounded, color: AppColors.notification.timerIcon),
                  ),
                  title: Text(
                    'Notifikasi by Timer',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'Hitung mundur 00:00:00 (High Priority)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: theme.textSecondary,
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right, color: theme.textSecondary),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showTimerNotificationDialog(rootContext);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    ),
  );
}

void _showTimerNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => _TimerNotificationDialog(hostContext: context),
  );
}


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
bool _notificationsInitialized = false;

Future<void> _initNotifications(BuildContext context) async {
  if (_notificationsInitialized) return;
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {},
  );
  
  // Meminta izin notifikasi secara eksplisit (Wajib untuk Android 13+)
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
      
  _notificationsInitialized = true;
}

Future<void> _showSystemUrgentNotification(BuildContext context) async {
  await _initNotifications(context);
  await ParkingNotificationService.showSystemUrgentNotificationDirectly();
}

Future<void> _showSystemInfoNotification(BuildContext context) async {
  await _initNotifications(context);
  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'info_channel_v2', 'Info Notifications',
    channelDescription: 'Informasi umum',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    id: 1,
    title: 'Pembelian Sukses',
    body: 'Voucher parkir berhasil ditambahkan ke dompet.',
    notificationDetails: platformChannelSpecifics,
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String subtitle;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({required this.icon, required this.subtitle, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeService.instance;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.card, 
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.border.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: theme.isDarkMode ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.02), 
              blurRadius: 12, 
              offset: const Offset(0, 2)
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: theme.chipBg, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, size: 22, color: theme.iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: theme.textSecondary, letterSpacing: 0.5)),
                  const SizedBox(height: 2),
                  Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold, color: theme.textPrimary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: theme.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ─── LENCANA MEMBER DENGAN EFEK KILAU CAHAYA BERGERAK (SEMUA TIER) ───
class _ShimmerMemberBadge extends StatefulWidget {
  final String tier;
  const _ShimmerMemberBadge({required this.tier});

  @override
  State<_ShimmerMemberBadge> createState() => _ShimmerMemberBadgeState();
}

class _ShimmerMemberBadgeState extends State<_ShimmerMemberBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -2.5, end: 2.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normTier = widget.tier.trim().toUpperCase();
    final List<Color> gradientColors;
    final Color shadowColor;
    final String label;

    if (normTier.contains('BRONZE')) {
      label = 'MEMBER BRONZE';
      gradientColors = AppColors.profile.badgeBronze;
      shadowColor = AppColors.profile.badgeBronze[1].withValues(alpha: 0.45);
    } else if (normTier.contains('SILVER')) {
      label = 'MEMBER SILVER';
      gradientColors = AppColors.profile.badgeSilver;
      shadowColor = AppColors.profile.badgeSilver[1].withValues(alpha: 0.5);
    } else if (normTier.contains('GOLD')) {
      label = 'MEMBER GOLD';
      gradientColors = AppColors.profile.badgeGold;
      shadowColor = AppColors.profile.badgeGold[1].withValues(alpha: 0.5);
    } else {
      // PLATINUM (default)
      label = 'MEMBER PLATINUM';
      gradientColors = AppColors.profile.badgePlatinum;
      shadowColor = AppColors.profile.badgePlatinum[1].withValues(alpha: 0.6);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Latar Badge Gradien sesuai Tier
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.workspace_premium, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Efek Kilau / Shimmer Cahaya Meluncur dari Kiri ke Kanan
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _shimmerAnim,
                builder: (context, _) {
                  final double x = _shimmerAnim.value;
                  return IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(x - 0.6, -0.8),
                          end: Alignment(x + 0.6, 0.8),
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.15),
                            Colors.white.withValues(alpha: 0.70),
                            Colors.white.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimerNotificationDialog extends StatefulWidget {
  final BuildContext hostContext;
  const _TimerNotificationDialog({required this.hostContext});

  @override
  State<_TimerNotificationDialog> createState() => _TimerNotificationDialogState();
}

class _TimerNotificationDialogState extends State<_TimerNotificationDialog> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  bool _isRunning = false;
  bool _isLoading = true;
  int? _targetMs;
  Timer? _ticker;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _restoreTimerIfActive();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _restoreTimerIfActive() async {
    final activeTarget = await NotificationService().getActiveTimerTargetMs();
    if (!mounted) return;
    if (activeTarget != null && activeTarget > DateTime.now().millisecondsSinceEpoch) {
      _targetMs = activeTarget;
      _isRunning = true;
      _updateFromRemaining();
      _startTicker();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _updateFromRemaining() {
    if (_targetMs == null) return;
    final remainingMs = _targetMs! - DateTime.now().millisecondsSinceEpoch;
    if (remainingMs <= 0) {
      _onTimerReachedZero();
      return;
    }
    final totalSec = (remainingMs / 1000).ceil();
    _hours = totalSec ~/ 3600;
    _minutes = (totalSec % 3600) ~/ 60;
    _seconds = totalSec % 60;
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted) return;
      final prevTotal = _hours * 3600 + _minutes * 60 + _seconds;
      _updateFromRemaining();
      final nextTotal = _hours * 3600 + _minutes * 60 + _seconds;
      if (_isRunning && nextTotal != prevTotal) {
        setState(() {});
      }
    });
  }

  Future<void> _onTimerReachedZero() async {
    _ticker?.cancel();
    _ticker = null;
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _targetMs = null;
      _hours = 0;
      _minutes = 0;
      _seconds = 0;
    });
    await NotificationService().handleForegroundTimerZero();
  }

  void _adjustUnit(String unit, int delta) {
    if (_isRunning) return;
    setState(() {
      _errorMsg = null;
      if (unit == 'h') {
        _hours = (_hours + delta) % 24;
        if (_hours < 0) _hours += 24;
      } else if (unit == 'm') {
        _minutes = (_minutes + delta) % 60;
        if (_minutes < 0) _minutes += 60;
      } else {
        _seconds = (_seconds + delta) % 60;
        if (_seconds < 0) _seconds += 60;
      }
    });
  }

  Future<void> _editUnitDirectly(String unit, String label, int maxVal, int currentVal) async {
    if (_isRunning) return;
    final controller = TextEditingController(text: currentVal.toString().padLeft(2, '0'));
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) {
        final theme = ThemeService.instance;
        return AlertDialog(
          backgroundColor: theme.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Atur $label (0 - $maxVal)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.textPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceField,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: theme.border),
              ),
            ),
            onSubmitted: (val) {
              final parsed = int.tryParse(val) ?? currentVal;
              Navigator.pop(ctx, parsed.clamp(0, maxVal));
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Batal', style: GoogleFonts.plusJakartaSans(color: theme.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final parsed = int.tryParse(controller.text) ?? currentVal;
                Navigator.pop(ctx, parsed.clamp(0, maxVal));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (result != null && mounted) {
      setState(() {
        _errorMsg = null;
        if (unit == 'h') _hours = result;
        if (unit == 'm') _minutes = result;
        if (unit == 's') _seconds = result;
      });
    }
  }

  Future<void> _onPlayPressed() async {
    if (_isRunning) return;
    final duration = Duration(hours: _hours, minutes: _minutes, seconds: _seconds);
    if (duration.inSeconds <= 0) {
      setState(() {
        _errorMsg = 'Atur durasi minimal 1 detik terlebih dahulu.';
      });
      return;
    }

    setState(() {
      _errorMsg = null;
    });

    final targetMs = await NotificationService().startTimerNotification(duration: duration);
    if (!mounted) return;
    setState(() {
      _targetMs = targetMs;
      _isRunning = true;
      _updateFromRemaining();
    });
    _startTicker();
  }

  Future<void> _onCancelPressed() async {
    if (_isRunning) {
      _ticker?.cancel();
      _ticker = null;
      await NotificationService().cancelTimerNotification();
      if (!mounted) return;
      Navigator.pop(context);
      if (widget.hostContext.mounted) {
        ScaffoldMessenger.of(widget.hostContext).showSnackBar(
          SnackBar(
            content: Text(
              'Timer notifikasi dibatalkan.',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeService.instance;
    final isDark = theme.isDarkMode;

    String scheduledClockText = '';
    if (_isRunning && _targetMs != null) {
      final dt = DateTime.fromMillisecondsSinceEpoch(_targetMs!);
      scheduledClockText =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(24),
            border: isDark ? Border.all(color: theme.border) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.notification.timerBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.hourglass_bottom_rounded,
                        color: AppColors.notification.timerIcon,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Timer Notifikasi',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.textPrimary,
                            ),
                          ),
                          Text(
                            _isRunning
                                ? 'Aktif hingga pukul $scheduledClockText'
                                : 'Prioritas High • Jalan di latar belakang',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: _isRunning
                                  ? AppColors.profile.kycVerified
                                  : theme.textSecondary,
                              fontWeight: _isRunning ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, size: 20, color: theme.textSecondary),
                      tooltip: 'Tutup dialog',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: CircularProgressIndicator(),
                  )
                else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimeSegment(
                        label: 'Jam',
                        value: _hours,
                        onInc: () => _adjustUnit('h', 1),
                        onDec: () => _adjustUnit('h', -1),
                        onTapDigit: () => _editUnitDirectly('h', 'Jam', 23, _hours),
                        theme: theme,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: _isRunning ? 18 : 22, left: 6, right: 6),
                        child: Text(
                          ':',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: theme.textPrimary,
                          ),
                        ),
                      ),
                      _buildTimeSegment(
                        label: 'Menit',
                        value: _minutes,
                        onInc: () => _adjustUnit('m', 1),
                        onDec: () => _adjustUnit('m', -1),
                        onTapDigit: () => _editUnitDirectly('m', 'Menit', 59, _minutes),
                        theme: theme,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: _isRunning ? 18 : 22, left: 6, right: 6),
                        child: Text(
                          ':',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: theme.textPrimary,
                          ),
                        ),
                      ),
                      _buildTimeSegment(
                        label: 'Detik',
                        value: _seconds,
                        onInc: () => _adjustUnit('s', 1),
                        onDec: () => _adjustUnit('s', -1),
                        onTapDigit: () => _editUnitDirectly('s', 'Detik', 59, _seconds),
                        theme: theme,
                      ),
                    ],
                  ),

                  if (_isRunning) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.profile.kycVerified.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.profile.kycVerified.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.profile.kycVerified,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Timer berjalan di OS. Tetap berbunyi walau app ditutup & latar belakang bersih.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.profile.kycVerified,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (_errorMsg != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMsg!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.statusOccupied,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _onCancelPressed,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _isRunning
                                ? AppColors.statusOccupied
                                : theme.textPrimary,
                            side: BorderSide(
                              color: _isRunning
                                  ? AppColors.statusOccupied
                                  : theme.border,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isRunning ? null : _onPlayPressed,
                          icon: const Icon(Icons.play_arrow_rounded, size: 20),
                          label: Text(
                            _isRunning ? 'Running' : 'Play',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppColors.secondary.withValues(alpha: 0.45),
                            disabledForegroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSegment({
    required String label,
    required int value,
    required VoidCallback onInc,
    required VoidCallback onDec,
    required VoidCallback onTapDigit,
    required ThemeService theme,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_isRunning)
          InkWell(
            onTap: onInc,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              child: Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 24,
                color: theme.textSecondary,
              ),
            ),
          ),
        GestureDetector(
          onTap: _isRunning ? null : onTapDigit,
          child: Container(
            width: 64,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceField,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isRunning ? AppColors.secondary : theme.border,
                width: _isRunning ? 1.5 : 1,
              ),
            ),
            child: Text(
              value.toString().padLeft(2, '0'),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: theme.textPrimary,
                fontFeatures: const [ui.FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
        if (!_isRunning)
          InkWell(
            onTap: onDec,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: theme.textSecondary,
              ),
            ),
          ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: theme.textSecondary,
          ),
        ),
      ],
    );
  }
}
