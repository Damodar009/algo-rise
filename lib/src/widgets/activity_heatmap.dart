import 'dart:math';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class ActivityHeatmap extends StatefulWidget {
  const ActivityHeatmap({super.key});

  @override
  State<ActivityHeatmap> createState() => _ActivityHeatmapState();
}

class _ActivityHeatmapState extends State<ActivityHeatmap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final List<List<double>> _gridOpacities;
  final Random _random = Random(42); // Seeded for consistent premium look

  @override
  void initState() {
    super.initState();
    // Pulse animation controller for the active cells on the rightmost columns
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Generate static values for 20 columns * 7 rows
    _gridOpacities = List.generate(20, (colIndex) {
      return List.generate(7, (rowIndex) {
        // Simulating some activity pattern:
        // Columns further right generally have more activity
        double baseChance = 0.3 + (colIndex / 20.0) * 0.5;
        if (_random.nextDouble() < baseChance) {
          return _random.nextDouble() * 0.8 + 0.2;
        } else {
          return 0.05; // Inactive
        }
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ACTIVITY HEATMAP',
                style: AppText.labelCaps.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
              ),
              Row(
                children: [
                  Text(
                    '14 Day Streak',
                    style: AppText.labelCode.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tertiaryFixedDim,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.local_fire_department,
                    color: AppColors.tertiaryFixedDim,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Horizontal grid scroll container
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(20, (colIndex) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Column(
                    children: List.generate(7, (rowIndex) {
                      final opacity = _gridOpacities[colIndex][rowIndex];
                      final isActive = opacity > 0.1;

                      Widget cell = Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(bottom: 4.0),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primaryFixedDim.withValues(alpha: opacity)
                              : AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );

                      // Last 2 columns pulse if they are active
                      if (colIndex >= 18 && isActive) {
                        cell = AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final currentOpacity = opacity *
                                (0.5 + 0.5 * _pulseController.value);
                            return Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.only(bottom: 4.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryFixedDim
                                    .withValues(alpha: currentOpacity),
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryFixedDim
                                        .withValues(alpha: 0.3 * _pulseController.value),
                                    blurRadius: 4,
                                    spreadRadius: 0.5,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return cell;
                    }),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),

          // Bottom Legend Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Less',
                style: AppText.labelCaps.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
              Row(
                children: [
                  _legendCell(AppColors.surfaceContainerHighest),
                  const SizedBox(width: 4),
                  _legendCell(AppColors.primaryFixedDim.withValues(alpha: 0.25)),
                  const SizedBox(width: 4),
                  _legendCell(AppColors.primaryFixedDim.withValues(alpha: 0.50)),
                  const SizedBox(width: 4),
                  _legendCell(AppColors.primaryFixedDim.withValues(alpha: 0.75)),
                  const SizedBox(width: 4),
                  _legendCell(AppColors.primaryFixedDim),
                ],
              ),
              Text(
                'More',
                style: AppText.labelCaps.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendCell(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
