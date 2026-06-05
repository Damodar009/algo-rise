import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';

/// Bottom navigation bar used across the app.
class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final items = [
      (Icons.home_outlined, Icons.home, 'Home'),
      (Icons.alarm, Icons.alarm, 'Alarms'),
      (Icons.trending_up, Icons.trending_up, 'Progress'),
      (Icons.person_outline, Icons.person, 'Profile'),
    ];
    return Container(
      height: 64 + bottom,
      padding: EdgeInsets.only(bottom: bottom),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.92),
        border: const Border(top: BorderSide(color: Colors.white10)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryFixedDim.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          final active = currentIndex == i;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: NavItem(
              icon: active ? item.$2 : item.$1,
              label: item.$3,
              active: active,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Individual navigation item used inside [BottomNav].
class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const NavItem({
    required this.icon,
    required this.label,
    required this.active,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.primaryFixedDim
        : AppColors.onSurfaceVariant;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        if (active)
          Positioned(
            top: -8,
            child: Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixedDim,
              ),
            ),
          ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: AppText.labelCaps.copyWith(
                fontSize: 10,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
