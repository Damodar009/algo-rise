import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class CtaFooter extends StatelessWidget {
  final Widget button;
  final String? subLabel;

  const CtaFooter({super.key, required this.button, this.subLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0.95),
            Colors.transparent,
          ],
          stops: const [0.0, 0.65, 1.0],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
          if (subLabel != null) ...[
            const SizedBox(height: 16),
            Text(
              subLabel!,
              style: AppText.labelCaps.copyWith(
                fontSize: 10,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
