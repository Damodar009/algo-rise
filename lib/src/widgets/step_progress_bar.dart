import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  final int step;
  final int total;

  const StepProgressBar({super.key, required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: SizedBox(
        height: 4,
        child: LinearProgressIndicator(
          value: step / total,
          backgroundColor: AppColors.surfaceContainerHighest,
          valueColor: const AlwaysStoppedAnimation(AppColors.primaryFixedDim),
        ),
      ),
    );
  }
}
