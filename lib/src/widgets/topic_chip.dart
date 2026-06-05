import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:flutter/material.dart';

class TopicChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const TopicChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sel = isSelected;
    return Pressable(
      onTap: onTap,
      scaleDown: 0.95,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: sel
              ? AppColors.primaryFixedDim.withValues(alpha: 0.10)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: sel
                ? AppColors.primaryFixedDim
                : Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: sel
              ? [
                  BoxShadow(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.20),
                    blurRadius: 20,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppText.labelCode.copyWith(
                color: sel ? AppColors.primaryFixedDim : AppColors.onSurface,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: sel
                  ? const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.check_circle,
                        size: 18,
                        color: AppColors.primaryFixedDim,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
