import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class AtmospherePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Top-left teal glow
    final paint1 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.primaryFixedDim.withOpacity(0.07),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.15, size.height * 0.2),
              radius: size.width * 0.6,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.2),
      size.width * 0.6,
      paint1,
    );

    // Bottom-right teal glow
    final paint2 = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.kPrimaryFixedDim.withOpacity(0.05),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.85, size.height * 0.8),
              radius: size.width * 0.5,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.8),
      size.width * 0.5,
      paint2,
    );
  }

  @override
  bool shouldRepaint(AtmospherePainter old) => false;
}
