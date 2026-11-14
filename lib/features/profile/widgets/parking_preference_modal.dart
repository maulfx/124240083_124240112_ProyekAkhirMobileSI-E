import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/theme_service.dart';
import '../../../theme/app_colors.dart';

class ParkingPreferenceModal {
  static void show(
    BuildContext context, {
    required String currentPref,
    required ValueChanged<String> onSelected,
  }) {
    final theme = ThemeService.instance;
    final isDark = theme.isDarkMode;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: isDark ? Border(top: BorderSide(color: AppColors.warmBorder)) : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.warmBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Preferensi Parkir',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SUV
                  GestureDetector(
                    onTap: () {
                      onSelected('Mobil SUV');
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: currentPref == 'Mobil SUV'
                            ? AppColors.surfaceField
                            : (isDark ? theme.card : Colors.transparent),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: currentPref == 'Mobil SUV'
                              ? AppColors.primary
                              : (isDark ? theme.border : Colors.transparent),
                          width: currentPref == 'Mobil SUV' ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Golongan Mobil SUV',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (currentPref == 'Mobil SUV')
                            Icon(
                              Icons.check_circle,
                              color: AppColors.textPrimary,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Sedan/City
                  GestureDetector(
                    onTap: () {
                      onSelected('Mobil Sedan/City');
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: currentPref == 'Mobil Sedan/City'
                            ? AppColors.surfaceField
                            : (isDark ? theme.card : Colors.transparent),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: currentPref == 'Mobil Sedan/City'
                              ? AppColors.primary
                              : (isDark ? theme.border : Colors.transparent),
                          width: currentPref == 'Mobil Sedan/City' ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Golongan Mobil Sedan/City',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (currentPref == 'Mobil Sedan/City')
                            Icon(
                              Icons.check_circle,
                              color: AppColors.textPrimary,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Motor Roda 2
                  GestureDetector(
                    onTap: () {
                      onSelected('Motor Roda 2');
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: currentPref == 'Motor Roda 2'
                            ? AppColors.surfaceField
                            : (isDark ? theme.card : Colors.transparent),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: currentPref == 'Motor Roda 2'
                              ? AppColors.primary
                              : (isDark ? theme.border : Colors.transparent),
                          width: currentPref == 'Motor Roda 2' ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.two_wheeler,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Motor Roda 2',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (currentPref == 'Motor Roda 2')
                            Icon(
                              Icons.check_circle,
                              color: AppColors.textPrimary,
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

