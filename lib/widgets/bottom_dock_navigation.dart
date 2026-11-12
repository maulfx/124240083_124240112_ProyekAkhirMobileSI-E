import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/map/explore_map_screen.dart';
import '../features/profile/profile_screen.dart';

enum DockTab { home, map, profile }

class BottomDockNavigation extends StatelessWidget {
  final DockTab activeTab;
  
  const BottomDockNavigation({super.key, required this.activeTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1D1F),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1C1D1F).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon(context, Icons.home_rounded, DockTab.home, () {
            if (activeTab != DockTab.home) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (route) => false);
            }
          }),
          _buildIcon(context, Icons.map_rounded, DockTab.map, () {
            if (activeTab != DockTab.map) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ExploreMapScreen()));
            }
          }),
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
      child: Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFD67B5A) : Colors.transparent,
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
