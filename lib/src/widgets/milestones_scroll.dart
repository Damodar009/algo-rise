import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class MilestonesScroll extends StatelessWidget {
  const MilestonesScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT MILESTONES',
          style: AppText.labelCaps.copyWith(
            fontSize: 10,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildMilestoneCard(
                title: 'Dawn Breaker',
                subtitle: '7 days sub 6:00 AM',
                icon: Icons.verified,
                iconColor: AppColors.tertiaryFixedDim,
              ),
              const SizedBox(width: 16),
              _buildMilestoneCard(
                title: 'Hard Coder',
                subtitle: 'Solved 1st Hard Alarm',
                icon: Icons.terminal,
                iconColor: AppColors.secondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return SizedBox(
      width: 250,
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Icon container with tinted circular background
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppText.bodyMd.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppText.labelCode.copyWith(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
