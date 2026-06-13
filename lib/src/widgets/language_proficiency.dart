import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class LanguageProficiency extends StatelessWidget {
  const LanguageProficiency({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              const Icon(
                Icons.code,
                color: AppColors.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'LANGUAGE PROFICIENCY',
                style: AppText.labelCaps.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Progress Bars List inside GlassCard
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProgressRow(
                language: 'Python',
                percentage: 88,
                color: AppColors.tertiaryFixedDim,
              ),
              const SizedBox(height: 16),
              _buildProgressRow(
                language: 'JavaScript',
                percentage: 64,
                color: AppColors.secondary,
              ),
              const SizedBox(height: 16),
              _buildProgressRow(
                language: 'Java',
                percentage: 12,
                color: AppColors.error,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressRow({
    required String language,
    required int percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: AppText.labelCode.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              '$percentage%',
              style: AppText.labelCode.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Linear Progress bar
        LayoutBuilder(
          builder: (context, constraints) {
            final double totalWidth = constraints.maxWidth;
            final double fillWidth = totalWidth * (percentage / 100);

            return Container(
              height: 6,
              width: totalWidth,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(
                children: [
                  Container(
                    width: fillWidth,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
