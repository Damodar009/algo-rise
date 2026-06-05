import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class NeonDivider extends StatelessWidget {
  const NeonDivider({super.key});

  Widget _bar(double w, double op, bool glow) => Container(
    height: 4,
    width: w,
    decoration: BoxDecoration(
      color: AppColors.primaryFixedDim.withValues(alpha: op),
      borderRadius: BorderRadius.circular(9999),
      boxShadow: glow
          ? [
              BoxShadow(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ]
          : null,
    ),
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Center(
      child: Opacity(
        opacity: 0.4,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _bar(32, 0.3, false),
            const SizedBox(width: 4),
            _bar(48, 1.0, true),
            const SizedBox(width: 4),
            _bar(24, 0.3, false),
          ],
        ),
      ),
    ),
  );
}
