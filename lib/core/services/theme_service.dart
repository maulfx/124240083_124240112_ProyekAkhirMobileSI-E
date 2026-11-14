import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_colors.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService instance = ThemeService._internal();
  ThemeService._internal();

  static const String _prefsKey = 'is_dark_mode';

  // Default false (Light Mode) when first installed
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // ─── [USER] WARNA PROXY KE APPCOLORS (SINGLE SOURCE OF TRUTH) ───
  // Ubah warna aplikasi langsung di: lib/theme/app_colors.dart
  Color get bg => AppColors.background;
  Color get bgSecondary => AppColors.surface;

  // Card / Surface colors
  Color get card => AppColors.surfaceCard;
  Color get cardAlt => AppColors.surfaceDim;
  Color get surfaceField => AppColors.surfaceField;

  // Text colors
  Color get textPrimary => AppColors.textPrimary;
  Color get textSecondary => AppColors.textSecondary;
  Color get textMuted => AppColors.textMuted;

  // Borders & Dividers
  Color get border => AppColors.warmBorder;
  Color get divider => AppColors.divider;

  // Buttons & Badges
  Color get buttonPrimary => AppColors.buttonPrimary;
  Color get buttonPrimaryText => AppColors.white;
  Color get chipBg => AppColors.chipBg;
  Color get iconContainer => AppColors.iconContainer;
  Color get iconColor => AppColors.iconColor;

  // Accent
  Color get accent => AppColors.secondary;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_prefsKey) ?? false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }

  Future<void> toggleTheme() async {
    await setDarkMode(!_isDarkMode);
  }
}
