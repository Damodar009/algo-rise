import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class BlinkingCursor extends StatelessWidget {
  final AnimationController controller;
  final double width;
  final double height;

  const BlinkingCursor({
    super.key,
    required this.controller,
    this.width = 8,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (_, __) => Opacity(
      opacity: controller.value < 0.5 ? 1.0 : 0.0,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(left: 4),
        color: AppColors.primaryFixedDim,
      ),
    ),
  );
}
