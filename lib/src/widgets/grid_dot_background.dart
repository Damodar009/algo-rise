import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class GridDotBackground extends StatelessWidget {
  const GridDotBackground({super.key});

  @override
  Widget build(BuildContext context) => Opacity(
    opacity: 0.2,
    child: CustomPaint(painter: _GridPainter(), child: const SizedBox.expand()),
  );
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.gridDot
      ..style = PaintingStyle.fill;
    for (double x = 0; x < size.width; x += 32) {
      for (double y = 0; y < size.height; y += 32) {
        canvas.drawCircle(Offset(x, y), 1.0, p);
      }
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
