import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'edit_profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/currency_service.dart';
import '../../core/services/theme_service.dart';
import '../../core/services/language_service.dart';
import '../../core/services/app_image_cache_service.dart';
import 'backend/profile_backend.dart';
import 'widgets/currency_selection_modal.dart';
import 'widgets/parking_preference_modal.dart';
import '../../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _userName = ProfileBackend.instance.name;
  String _userEmail = ProfileBackend.instance.email;
  String _userPhone = ProfileBackend.instance.phone;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadActualCacheSize();
    CurrencyService.instance.addListener(_onCurrencyChanged);
    ThemeService.instance.addListener(_onThemeChanged);
    ProfileBackend.instance.addListener(_onProfileChanged);
    LanguageService.instance.addListener(_onLanguageChanged);
  }

  Future<void> _loadActualCacheSize() async {
    final size = await AppImageCacheService.instance.getFormattedCacheSize();
    if (mounted) {
      setState(() {
        _cacheSize = size;
        _isCacheCleared = size.startsWith('0');
      });
    }
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onCurrencyChanged() {
    if (mounted) setState(() {});
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  void _onProfileChanged() {
    if (mounted) {
      setState(() {
        _userName = ProfileBackend.instance.name;
        _userEmail = ProfileBackend.instance.email;
        _userPhone = ProfileBackend.instance.phone;
        _avatarUrl = ProfileBackend.instance.avatarUrl;
      });
    }
  }

  @override
  void dispose() {
    CurrencyService.instance.removeListener(_onCurrencyChanged);
    ThemeService.instance.removeListener(_onThemeChanged);
    ProfileBackend.instance.removeListener(_onProfileChanged);
    LanguageService.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  Widget _buildFallbackAvatar(double size) {
    final initial = _userName.trim().isNotEmpty ? _userName.trim()[0].toUpperCase() : 'U';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: GoogleFonts.plusJakartaSans(
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final fpEnabled = prefs.getBool('fingerprint_enabled') ?? false;

    final profile = ProfileBackend.instance;
    await profile.fetchProfile();

    final prefName = prefs.getString('user_profile_name');
    final name = (prefName != null && prefName.isNotEmpty)
        ? prefName
        : profile.name;
    final prefEmail = prefs.getString('user_profile_email');
    final email = (prefEmail != null && prefEmail.isNotEmpty)
        ? prefEmail
        : profile.email;
    final prefPhone = prefs.getString('user_profile_phone');
    final phone = (prefPhone != null && prefPhone.isNotEmpty)
        ? prefPhone
        : profile.phone;

    if (mounted) {
      setState(() {
        _userName = name;
        _userEmail = email;
        _userPhone = phone;
        _avatarUrl = profile.avatarUrl;
        _fingerprintEnabled = fpEnabled;
      });
    }
  }

  bool _fingerprintEnabled = false;
  bool _notifEnabled = true;
  String _cacheSize = 'Menghitung...';
  bool _isCacheCleared = false;
  String _selectedParkingPref = 'Mobil SUV';

  // ============================================================================
  // [PETUNJUK PRESENTASI - BIOMETRIK: SIDIK JARI (FINGERPRINT / LOCAL_AUTH)]
  // Package: local_auth (LocalAuthentication)
  // Cara Kerja:
  // 1. Memeriksa dukungan hardware perangkat (auth.isDeviceSupported & canCheckBiometrics).
  // 2. Mengecek apakah tipe sensor sidik jari terdaftar (BiometricType.fingerprint).
  // 3. Menjalankan sensor bawaan Android/iOS (auth.authenticate).
  // 4. Jika sukses, menyimpan flag 'fingerprint_enabled' & 'biometric_user_email' di SharedPreferences.
  // ============================================================================
  Future<void> _handleFingerprintToggle(bool val) async {
    if (!val) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('fingerprint_enabled', false);
      await prefs.remove('biometric_user_email');
      await prefs.remove('biometric_user_id');
      setState(() => _fingerprintEnabled = false);
      _showSuccessToast('Sidik Jari dinonaktifkan');
      return;
    }

    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool isSupported = await auth.isDeviceSupported();
      final bool canCheck = await auth.canCheckBiometrics;
      final List<BiometricType> available = await auth.getAvailableBiometrics();

      debugPrint('Biometrics FP check - supported: $isSupported, canCheck: $canCheck, available: $available');

      final bool hasFingerprint = isSupported &&
          canCheck &&
          (available.contains(BiometricType.fingerprint) ||
              available.contains(BiometricType.strong));

      if (!hasFingerprint) {
        _showBiometricSystemOffDialog(
          title: 'Pengaturan Sidik Jari Sistem Mati',
          message:
              'Fitur Sidik Jari (Fingerprint) belum diaktifkan atau belum didaftarkan pada pengaturan keamanan sistem Android perangkat Anda.\n\nSilakan daftarkan sidik jari Anda terlebih dahulu di Pengaturan HP > Keamanan > Biometrik.',
          icon: Icons.fingerprint,
        );
        setState(() => _fingerprintEnabled = false);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('fingerprint_enabled', false);
        return;
      }

      final bool authenticated = await auth.authenticate(
        localizedReason: 'Sentuh sensor sidik jari untuk mengaktifkan',
        biometricOnly: true,
      );

      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('fingerprint_enabled', true);
        final currentEmail = ProfileBackend.instance.email;
        final currentUserId = ProfileBackend.instance.userId;
        await prefs.setString('biometric_user_email', currentEmail);
        await prefs.setString('biometric_user_id', currentUserId);
        setState(() => _fingerprintEnabled = true);
        _showSuccessToast('Sidik Jari berhasil diaktifkan untuk akun $currentEmail');
      } else {
        setState(() => _fingerprintEnabled = false);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('fingerprint_enabled', false);
        await prefs.remove('biometric_user_email');
        await prefs.remove('biometric_user_id');
      }
    } on PlatformException catch (e) {
      debugPrint('Fingerprint error: ${e.message}');
      _showBiometricSystemOffDialog(
        title: 'Pengaturan Sidik Jari Sistem Mati',
        message:
            'Sensor sidik jari tidak aktif atau belum didaftarkan pada sistem Android perangkat Anda (${e.message ?? 'Tidak aktif'}).',
        icon: Icons.fingerprint,
      );
      setState(() => _fingerprintEnabled = false);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('fingerprint_enabled', false);
      await prefs.remove('biometric_user_email');
      await prefs.remove('biometric_user_id');
    } catch (e) {
      _showBiometricSystemOffDialog(
        title: 'Pengaturan Sidik Jari Sistem Mati',
        message:
            'Gagal mengakses sensor sidik jari perangkat. Pastikan sensor biometrik diaktifkan pada pengaturan sistem perangkat Anda.',
        icon: Icons.fingerprint,
      );
      setState(() => _fingerprintEnabled = false);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('fingerprint_enabled', false);
      await prefs.remove('biometric_user_email');
      await prefs.remove('biometric_user_id');
    }
  }

  void _showBiometricSystemOffDialog({
    required String title,
    required String message,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: ThemeService.instance.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: AppColors.secondary),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: ThemeService.instance.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: ThemeService.instance.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Mengerti',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessToast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }


  void _showCurrencySelectionModal(BuildContext context) {
    CurrencySelectionModal.show(
      context,
      onToast: _showSuccessToast,
      onUpdated: () => setState(() {}),
    );
  }

  void _showParkingPrefSelection(BuildContext context) {
    ParkingPreferenceModal.show(
      context,
      currentPref: _selectedParkingPref,
      onSelected: (val) => setState(() => _selectedParkingPref = val),
    );
  }
  void _showLanguageSelection(BuildContext context) {
    LanguageService.showLanguageSelectionModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.instance.bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: ThemeService.instance.bg.withValues(alpha: 0.9),
                boxShadow: [
                  BoxShadow(
                    color: ThemeService.instance.isDarkMode 
                        ? Colors.black.withValues(alpha: 0.3) 
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8, 
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: ThemeService.instance.chipBg, 
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.arrow_back, size: 20, color: ThemeService.instance.iconColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.settings, 
                            size: 24, 
                            color: AppColors.auth.linkBlue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Pengaturan', 
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold, 
                              color: ThemeService.instance.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Profile Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ThemeService.instance.card, 
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ThemeService.instance.border.withValues(alpha: 0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeService.instance.isDarkMode 
                              ? Colors.black.withValues(alpha: 0.25) 
                              : AppColors.warmBorder.withValues(alpha: 0.2), 
                          blurRadius: 32, 
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            ClipOval(
                              child: _avatarUrl != null && _avatarUrl!.isNotEmpty
                                  ? AppCachedNetworkImage(
                                      imageUrl: _avatarUrl!,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(56),
                                    )
                                  : _buildFallbackAvatar(56),
                            ),
                            Positioned(
                              bottom: 0, right: 0,
                              child: Container(
                                width: 16, height: 16,
                                decoration: BoxDecoration(color: AppColors.slot.tertiaryFixed, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                                child: Icon(Icons.check, size: 10, color: AppColors.slot.ev),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      _userName,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeService.instance.textPrimary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.verified, size: 16, color: AppColors.warmTerracotta),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _userEmail,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: ThemeService.instance.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _userPhone,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: ThemeService.instance.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Tombol Icon Pensil Hitam Vertically Centered
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  initialName: _userName,
                                  initialEmail: _userEmail,
                                  initialPhone: _userPhone,
                                ),
                              ),
                            );
                            if (result != null && result is Map<String, String>) {
                              setState(() {
                                _userName = result['name'] ?? _userName;
                                _userEmail = result['email'] ?? _userEmail;
                                _userPhone = result['phone'] ?? _userPhone;
                              });
                            }
                          },
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: ThemeService.instance.chipBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: ThemeService.instance.iconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Section 1: Akun & Keamanan
                  _SectionTitle(title: 'Akun & Keamanan', icon: Icons.lock),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ThemeService.instance.card, 
                      borderRadius: BorderRadius.circular(16), 
                      border: Border.all(color: ThemeService.instance.border.withValues(alpha: 0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeService.instance.isDarkMode ? Colors.black.withValues(alpha: 0.2) : AppColors.warmBorder.withValues(alpha: 0.2), 
                          blurRadius: 12, 
                          offset: const Offset(0, 4)
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _SettingToggleRow(
                          icon: Icons.fingerprint, title: 'Fingerprint', subtitle: 'Login dengan sidik jari',
                          value: _fingerprintEnabled,
                          onChanged: (val) => _handleFingerprintToggle(val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Section 2: Preferensi Aplikasi
                  _SectionTitle(title: 'Preferensi Aplikasi', icon: Icons.tune),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ThemeService.instance.card, 
                      borderRadius: BorderRadius.circular(16), 
                      border: Border.all(color: ThemeService.instance.border.withValues(alpha: 0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeService.instance.isDarkMode ? Colors.black.withValues(alpha: 0.2) : AppColors.warmBorder.withValues(alpha: 0.2), 
                          blurRadius: 12, 
                          offset: const Offset(0, 4)
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _SettingActionRow(
                          icon: Icons.language,
                          title: 'Bahasa'.tr,
                          subtitle: LanguageService.instance.isEnglish ? 'English' : 'Bahasa Indonesia',
                          actionWidget: Icon(Icons.chevron_right, color: AppColors.textPrimary),
                          onTap: () => _showLanguageSelection(context),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Divider(color: ThemeService.instance.divider, height: 1)),
                          _SettingActionRow(
                            icon: Icons.local_parking, title: 'Preferensi Parkir', subtitle: _selectedParkingPref, actionWidget: Icon(Icons.chevron_right, color: AppColors.textPrimary),
                            onTap: () => _showParkingPrefSelection(context),
                          ),
                          Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Divider(color: ThemeService.instance.divider, height: 1)),
                        _SettingActionRow(
                          icon: Icons.payments,
                          title: 'Mata Uang & Kurs Valuta',
                          subtitle: CurrencyService.instance.isConversionEnabled
                              ? '${CurrencyService.instance.currentCurrency} (${CurrencyService.instance.currentInfo.name}) - Konversi Aktif'
                              : 'IDR (Rupiah Indonesia) - Standar',
                          actionWidget: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: CurrencyService.instance.isConversionEnabled
                                      ? AppColors.home.promoTagBg
                                      : AppColors.surfaceField,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  CurrencyService.instance.isConversionEnabled
                                      ? CurrencyService.instance.currentCurrency
                                      : 'IDR (OFF)',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: CurrencyService.instance.isConversionEnabled
                                        ? AppColors.home.promoTagText
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.chevron_right, size: 16, color: AppColors.textPrimary),
                            ],
                          ),
                          onTap: () => _showCurrencySelectionModal(context),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Divider(color: ThemeService.instance.divider, height: 1)),
                        _SettingToggleRow(
                          icon: Icons.notifications_active, title: 'Notifikasi Sesi & Promo', subtitle: 'Pemberitahuan durasi & cashback',
                          value: _notifEnabled,
                          onChanged: (val) => setState(() => _notifEnabled = val),
                        ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Divider(color: ThemeService.instance.divider, height: 1)),
                        _SettingToggleRow(
                          icon: ThemeService.instance.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          title: ThemeService.instance.isDarkMode ? 'Dark Mode' : 'Light Mode',
                          subtitle: '',
                          value: ThemeService.instance.isDarkMode,
                          onChanged: (val) {
                            ThemeService.instance.setDarkMode(val);
                            _showSuccessToast(val ? 'Dark mode diaktifkan' : 'Light mode diaktifkan');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Section 3: Privasi & Data
                  _SectionTitle(title: 'Privasi & Data', icon: Icons.shield),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ThemeService.instance.card, 
                      borderRadius: BorderRadius.circular(16), 
                      border: Border.all(color: ThemeService.instance.border.withValues(alpha: 0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeService.instance.isDarkMode ? Colors.black.withValues(alpha: 0.2) : AppColors.warmBorder.withValues(alpha: 0.2), 
                          blurRadius: 12, 
                          offset: const Offset(0, 4)
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        Row(
                          children: [
                            Container(width: 40, height: 40, decoration: BoxDecoration(color: ThemeService.instance.chipBg, shape: BoxShape.circle), child: Icon(Icons.cleaning_services, size: 20, color: ThemeService.instance.iconColor)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hapus Riwayat Cache', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: ThemeService.instance.textPrimary)),
                                  Text(_cacheSize, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: ThemeService.instance.textSecondary)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _isCacheCleared ? null : () async {
                                final messenger = ScaffoldMessenger.of(context);
                                await AppImageCacheService.instance.clearAllCache();
                                if (!mounted) return;
                                setState(() {
                                  _cacheSize = '0 KB tersimpan';
                                  _isCacheCleared = true;
                                });
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Cache perangkat berhasil dibersihkan!'.tr),
                                    backgroundColor: AppColors.accentTeal,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(color: ThemeService.instance.chipBg, borderRadius: BorderRadius.circular(16)),
                                child: _isCacheCleared 
                                  ? Row(children: [Icon(Icons.done, size: 14, color: AppColors.textSecondary), const SizedBox(width: 4), Text('Beres'.tr, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary))])
                                  : Text('Bersihkan'.tr, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: ThemeService.instance.textPrimary)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  

                  
                  Center(
                    child: Column(
                      children: [
                      
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.token, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text('Made by Love 🗿', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: ThemeService.instance.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(), 
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: ThemeService.instance.textSecondary, 
            letterSpacing: 1.0,
          ),
        ),
        Icon(icon, size: 16, color: ThemeService.instance.textSecondary),
      ],
    );
  }
}

class _SettingToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingToggleRow({
    required this.icon,
    required this.title,
    this.subtitle = '',
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: ThemeService.instance.chipBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: ThemeService.instance.iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: ThemeService.instance.textPrimary,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: ThemeService.instance.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: AppColors.secondary,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: AppColors.warmBorder,
          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        ),
      ],
    );
  }
}

class _SettingActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? actionWidget;
  final VoidCallback? onTap;

  const _SettingActionRow({
    required this.icon, 
    required this.title, 
    required this.subtitle, 
    this.actionWidget, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 40, 
            height: 40, 
            decoration: BoxDecoration(
              color: ThemeService.instance.chipBg, 
              shape: BoxShape.circle,
            ), 
            child: Icon(icon, size: 20, color: ThemeService.instance.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, 
                    fontWeight: FontWeight.w600, 
                    color: ThemeService.instance.textPrimary,
                  ),
                ),
                if (subtitle.isNotEmpty) 
                  Text(
                    subtitle, 
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, 
                      color: ThemeService.instance.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          ?actionWidget,
        ],
      ),
    );
  }
}


