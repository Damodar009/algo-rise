import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class RankProgressCard extends StatelessWidget {
  final String rankName;
  final String nextRank;
  final int xpToNext;
  final double progress; // 0.0 to 1.0

  const RankProgressCard({
    super.key,
    required this.rankName,
    required this.nextRank,
    required this.xpToNext,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RANK',
                    style: AppText.labelCaps.copyWith(
                      fontSize: 10,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rankName,
                    style: AppText.headlineMd.copyWith(
                      fontSize: 20,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                '$xpToNext XP to $nextRank',
                style: AppText.labelCode.copyWith(
                  fontSize: 12,
                  color: AppColors.tertiaryFixedDim,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.tertiaryFixedDim,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.tertiaryFixedDim.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
