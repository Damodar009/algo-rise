import 'dart:math';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/services/preferences_service.dart';

class VerdictDistribution extends StatelessWidget {
  const VerdictDistribution({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VERDICT DISTRIBUTION',
            style: AppText.labelCaps.copyWith(
              fontSize: 10,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Radial / Donut Chart
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _DonutChartPainter(),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${PreferencesService.instance.solvedCount}',
                            style: AppText.headlineMd.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            'SOLVED',
                            style: AppText.labelCaps.copyWith(
                              fontSize: 7,
                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      color: AppColors.tertiaryFixedDim,
                      label: 'AC: 70%',
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      color: AppColors.error,
                      label: 'WA: 15%',
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      color: AppColors.secondary,
                      label: 'TLE: 10%',
                    ),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                      color: AppColors.primaryFixedDim,
                      label: 'Other: 5%',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 4,
                spreadRadius: 0.5,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppText.labelCode.copyWith(
            fontSize: 13,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 6; // Leave padding for stroke width

    final rect = Rect.fromCircle(center: center, radius: radius);
    final double startAngle = -pi / 2; // Start from top (-90 degrees)

    final values = [0.70, 0.15, 0.10, 0.05];
    final colors = [
      AppColors.tertiaryFixedDim,
      AppColors.error,
      AppColors.secondary,
      AppColors.primaryFixedDim,
    ];

    double currentStartAngle = startAngle;
    final double gapAngle = 0.04; // Small gap between segments for modern look

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = values[i] * 2 * pi;
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      // Draw segment path slightly shorter to accommodate spacing/gap and round cap overlaps
      final adjustedSweep = sweepAngle - gapAngle;
      if (adjustedSweep > 0) {
        canvas.drawArc(
          rect,
          currentStartAngle + (gapAngle / 2),
          adjustedSweep,
          false,
          paint,
        );
      }

      currentStartAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
