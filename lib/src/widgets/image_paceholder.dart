// ─── Fallback if asset not found ──────────────────────────────────────────────
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class RobotPlaceholder extends StatelessWidget {
  const RobotPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.smart_toy_outlined,
          size: 80,
          color: AppColors.primaryFixedDim,
        ),
        const SizedBox(height: 8),
        Text(
          'assets/images/empty_robot.png',
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 10,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
