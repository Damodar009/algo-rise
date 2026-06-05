import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/grid_dot_background.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: GridDotBackground()),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Progress',
                  style: AppText.headlineMd.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  'Track your algorithm skills development.',
                  style: AppText.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Skill card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'LeetCode Master',
                            style: AppText.headlineMd.copyWith(fontSize: 18),
                          ),
                          const Icon(
                            Icons.stars,
                            color: AppColors.primaryFixedDim,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const LinearProgressIndicator(
                        value: 0.35,
                        backgroundColor: AppColors.surfaceContainerHigh,
                        color: AppColors.primaryFixedDim,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Level 4 • 350 / 1000 XP',
                        style: AppText.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: [
                    _buildStatCard(
                      'Solved',
                      '12',
                      Icons.task_alt,
                      AppColors.tertiaryFixedDim,
                    ),
                    _buildStatCard(
                      'Accuracy',
                      '84%',
                      Icons.gps_fixed,
                      AppColors.secondary,
                    ),
                    _buildStatCard(
                      'Streaks',
                      '0 days',
                      Icons.local_fire_department,
                      AppColors.tertiaryFixed,
                    ),
                    _buildStatCard(
                      'Rank',
                      '#4,192',
                      Icons.trending_up,
                      AppColors.primaryFixedDim,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppText.labelCaps.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppText.headlineMd.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
