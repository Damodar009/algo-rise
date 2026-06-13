import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class DailyChallengeCard extends StatelessWidget {
  final String title;
  final String difficulty;
  final String language;
  final int bonusXp;
  final VoidCallback? onSolve;

  const DailyChallengeCard({
    super.key,
    required this.title,
    required this.difficulty,
    required this.language,
    this.bonusXp = 15,
    this.onSolve,
  });

  Color get _difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.tertiaryFixedDim;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: AppColors.secondary, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Text(
                "TODAY'S CHALLENGE",
                style: AppText.labelCaps.copyWith(
                  fontSize: 10,
                  color: AppColors.secondary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              // Title row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppText.headlineMd.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _Badge(
                              label: difficulty,
                              color: _difficultyColor,
                              bgColor: AppColors.secondary.withValues(alpha: 0.1),
                              borderColor: AppColors.secondary.withValues(alpha: 0.25),
                            ),
                            const SizedBox(width: 8),
                            _Badge(
                              label: language,
                              color: AppColors.primaryFixed,
                              bgColor: AppColors.primaryContainer.withValues(alpha: 0.1),
                              borderColor: AppColors.primaryFixed.withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: const Icon(
                      Icons.terminal,
                      color: AppColors.primaryFixedDim,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Solve button
              Material(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: onSolve,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryFixedDim.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Solve Challenge → +$bonusXp bonus XP',
                        style: AppText.labelCaps.copyWith(
                          fontSize: 11,
                          color: AppColors.primaryFixedDim,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  final Color borderColor;

  const _Badge({
    required this.label,
    required this.color,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
