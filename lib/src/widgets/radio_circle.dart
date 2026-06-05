import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class RadioCircle extends StatelessWidget {
  final bool selected;
  const RadioCircle({super.key, required this.selected});

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 200),
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: selected ? AppColors.primaryFixedDim : Colors.transparent,
      border: Border.all(
        color: selected
            ? AppColors.primaryFixedDim
            : Colors.white.withValues(alpha: 0.2),
        width: selected ? 2 : 1,
      ),
    ),
    child: Center(
      child: AnimatedScale(
        scale: selected ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.background,
          ),
        ),
      ),
    ),
  );
}
