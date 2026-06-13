import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class XpProgressionChart extends StatelessWidget {
  const XpProgressionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'XP PROGRESSION',
            style: AppText.labelCaps.copyWith(
              fontSize: 10,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          // Chart Container
          SizedBox(
            height: 140,
            child: Stack(
              children: [
                // Background grid lines (4 horizontal lines drawn using a CustomPainter or simple Row/Column)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _XpChartGridPainter(),
                  ),
                ),
                // Neon Green bezier curve and gradient fill
                Positioned.fill(
                  child: CustomPaint(
                    painter: _XpChartCurvePainter(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // X-Axis Labels Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAxisLabel('Mon'),
              _buildAxisLabel('Wed'),
              _buildAxisLabel('Fri'),
              _buildAxisLabel('Sun'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAxisLabel(String text) {
    return Text(
      text,
      style: AppText.labelCode.copyWith(
        fontSize: 10,
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
      ),
    );
  }
}

class _XpChartGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final double step = size.height / 3;
    for (int i = 0; i <= 3; i++) {
      final double y = i * step;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _XpChartCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Define points corresponding to: Mon(0%), Wed(33%), Fri(66%), Sun(100%)
    // Normalized y coordinates (0 at top, 1 at bottom):
    // Mon: 90% down (height * 0.90)
    // Tue/Wed: 60% down (height * 0.60)
    // Thu/Fri: 45% down (height * 0.45)
    // Sat: 20% down (height * 0.20)
    // Sun: 5% down (height * 0.05)
    final points = [
      Offset(0, height * 0.90),
      Offset(width * 0.25, height * 0.75),
      Offset(width * 0.50, height * 0.45),
      Offset(width * 0.75, height * 0.20),
      Offset(width, height * 0.05),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Fill Path (under the curve)
    final fillPath = Path.from(path);
    fillPath.lineTo(width, height);
    fillPath.lineTo(0, height);
    fillPath.close();

    final fillGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.tertiaryFixedDim.withValues(alpha: 0.25),
        AppColors.tertiaryFixedDim.withValues(alpha: 0.0),
      ],
    );

    final fillPaint = Paint()
      ..shader = fillGradient.createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Stroke Path (the line itself with shadow glow)
    final strokePaint = Paint()
      ..color = AppColors.tertiaryFixedDim
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Drawing shadow/glow
    final glowPaint = Paint()
      ..color = AppColors.tertiaryFixedDim.withValues(alpha: 0.3)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
