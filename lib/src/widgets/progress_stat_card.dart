import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class ProgressStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? unit;

  const ProgressStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.labelCaps.copyWith(
              fontSize: 10,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          unit != null
              ? RichText(
                  text: TextSpan(
                    style: AppText.displayMobile.copyWith(
                      fontSize: 22,
                      color: AppColors.primary,
                      height: 1.1,
                    ),
                    children: [
                      TextSpan(text: value),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: unit,
                        style: AppText.bodyMd.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.displayMobile.copyWith(
                    fontSize: 22,
                    color: AppColors.primary,
                    height: 1.1,
                  ),
                ),
        ],
      ),
    );
  }
}
