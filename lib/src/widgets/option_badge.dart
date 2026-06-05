import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class OptionBadge extends StatelessWidget {
  final String text;
  final bool active;

  const OptionBadge({super.key, required this.text, this.active = false});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: active
          ? AppColors.onPrimaryFixedVariant.withValues(alpha: 0.2)
          : AppColors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(4),
      border: active
          ? Border.all(color: AppColors.primaryFixedDim.withValues(alpha: 0.3))
          : null,
    ),
    child: Text(
      text,
      style: AppText.labelCaps.copyWith(
        fontSize: 10,
        color: active ? AppColors.primaryFixedDim : AppColors.onSurfaceVariant,
      ),
    ),
  );
}
