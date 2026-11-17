import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../features/home/home_screen.dart';
import '../features/map/explore_map_screen.dart';
import '../features/parking_notes/parking_notes_screen.dart';
import '../features/profile/profile_screen.dart';

enum DockTab { home, map, notes, profile }

class BottomDockNavigation extends StatelessWidget {
  final DockTab activeTab;
  
  const BottomDockNavigation({super.key, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.dockBg,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.dockBg.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(context, Icons.home_rounded, DockTab.home, () {
            if (activeTab != DockTab.home) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
            }
          }),
          const SizedBox(width: 8),
          _buildIcon(context, Icons.map_rounded, DockTab.map, () {
            if (activeTab != DockTab.map) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ExploreMapScreen()));
            }
          }),
          const SizedBox(width: 8),
          _buildIcon(context, Icons.note_alt_rounded, DockTab.notes, () {
            if (activeTab != DockTab.notes) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ParkingNotesScreen()));
            }
          }),
          const SizedBox(width: 8),
          _buildIcon(context, Icons.person_rounded, DockTab.profile, () {
            if (activeTab != DockTab.profile) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            }
          }),
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon, DockTab tab, VoidCallback onTap) {
    final isActive = activeTab == tab;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 22,
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}
