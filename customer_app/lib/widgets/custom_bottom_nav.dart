import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '../theme.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  void _onNavTapped(BuildContext context, int index) {
    if (currentIndex == index) return; // Do nothing if already on the same tab
    
    if (index == 0) Navigator.pushReplacementNamed(context, '/home');
    if (index == 1) Navigator.pushReplacementNamed(context, '/history');
    if (index == 2) Navigator.pushReplacementNamed(context, '/chat');
    if (index == 3) Navigator.pushReplacementNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.96),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, 0, TablerIcons.home, Icons.home_rounded, 'HOME'),
          _buildNavItem(context, 1, TablerIcons.receipt, TablerIcons.receipt_filled, 'ORDERS'),
          _buildNavItem(context, 2, TablerIcons.message_circle, TablerIcons.message_circle_filled, 'CHAT'),
          _buildNavItem(context, 3, TablerIcons.user, TablerIcons.user_filled, 'PROFILE'),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, IconData selectedIcon, String label) {
    final bool isSelected = currentIndex == index;
    final Color itemColor = isSelected ? AppTheme.primaryRed : AppTheme.textSecondary;

    return GestureDetector(
      onTap: () => _onNavTapped(context, index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 22,
              color: itemColor,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontFamily: 'Inter', 
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: itemColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
