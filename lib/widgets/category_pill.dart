import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

class CategoryPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final bool tealIcon;
  final VoidCallback? onTap;

  const CategoryPill({
    super.key,
    required this.label,
    required this.icon,
    this.active = false,
    this.tealIcon = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceCard,
          borderRadius: AppRadii.pillRadius,
          boxShadow: active ? null : const [AppShadows.soft],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: active
                  ? AppColors.white
                  : (tealIcon ? AppColors.accentTeal : AppColors.textSecondary),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelSm(
                color: active ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

