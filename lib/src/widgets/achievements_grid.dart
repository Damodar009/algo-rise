import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';

class AchievementsGrid extends StatelessWidget {
  const AchievementsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Heading with "View All" button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.military_tech,
                  color: AppColors.onSurfaceVariant,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'ACHIEVEMENTS',
                  style: AppText.labelCaps.copyWith(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View All',
                style: AppText.labelCode.copyWith(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Grid of 4 achievements
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAchievement(
              title: 'Early Bird',
              icon: Icons.rocket_launch,
              color: AppColors.primaryFixedDim,
              isUnlocked: true,
            ),
            _buildAchievement(
              title: 'Fast Solver',
              icon: Icons.bolt,
              color: AppColors.tertiaryFixedDim,
              isUnlocked: true,
            ),
            _buildAchievement(
              title: 'God Mode',
              icon: Icons.lock,
              color: AppColors.onSurfaceVariant,
              isUnlocked: false,
            ),
            _buildAchievement(
              title: 'Legacy',
              icon: Icons.lock,
              color: AppColors.onSurfaceVariant,
              isUnlocked: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievement({
    required String title,
    required IconData icon,
    required Color color,
    required bool isUnlocked,
  }) {
    final double size = 56;
    final r = BorderRadius.circular(28);

    Widget badgeCircle = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: r,
        border: Border.all(
          color: isUnlocked
              ? color.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.1),
          width: isUnlocked ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            children: [
              if (isUnlocked)
                Center(
                  child: Container(
                    width: size - 8,
                    height: size - 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.08),
                    ),
                  ),
                ),
              Center(
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.4,
      child: Column(
        children: [
          badgeCircle,
          const SizedBox(height: 8),
          Text(
            title,
            style: AppText.labelCode.copyWith(
              fontSize: 10,
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
