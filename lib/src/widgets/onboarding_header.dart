import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/step_progress_bar.dart';
import 'package:flutter/material.dart';

/// Standardised onboarding top-bar.
///
/// Usage variants:
/// ```dart
/// // With progress bar
/// OnboardingHeader(step: 3, total: 7)
///
/// // With a custom centre widget and a "Skip" trailing button
/// OnboardingHeader(
///   step: 1, total: 7,
///   trailing: TextButton(onPressed: onSkip, child: Text('Skip')),
/// )
/// ```
class OnboardingHeader extends StatelessWidget {
  /// Optional step number (1-based). If provided alongside [total],
  /// a [StepProgressBar] and step label are rendered below the nav row.
  final int? step;
  final int? total;

  /// Widget rendered in the centre slot. Defaults to a "STEP N OF T" label.
  final Widget? center;

  /// Widget rendered in the trailing slot. Defaults to a 40-px spacer.
  final Widget? trailing;

  /// Colour of the back-arrow icon.
  final Color? backIconColor;

  final Color? backgroundColor;

  /// Height of the nav row (excl. progress bar). Default 56.
  final double height;

  final Border? border;

  /// If true, the back button is hidden (useful for step 1).
  final bool hideBack;

  const OnboardingHeader({
    super.key,
    this.step,
    this.total,
    this.center,
    this.trailing,
    this.backIconColor,
    this.backgroundColor,
    this.height = 56,
    this.border,
    this.hideBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final showProgress = step != null && total != null;

    // Default centre: "STEP N OF T" caps label
    Widget centreWidget = center ??
        (showProgress
            ? Text('STEP $step OF $total', style: AppText.labelCaps)
            : const SizedBox.shrink());

    return Container(
      decoration: BoxDecoration(
        color:
            (backgroundColor ?? AppColors.background).withValues(alpha: 0.92),
        border: border,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ── Back button ──────────────────────────────────────
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: hideBack
                          ? const SizedBox.shrink()
                          : Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(9999),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(9999),
                                onTap: () => Navigator.maybePop(context),
                                child: Icon(
                                  Icons.arrow_back,
                                  color:
                                      backIconColor ?? AppColors.onSurface,
                                  size: 24,
                                ),
                              ),
                            ),
                    ),

                    // ── Centre slot ──────────────────────────────────────
                    centreWidget,

                    // ── Trailing slot / spacer ───────────────────────────
                    trailing ?? const SizedBox(width: 40),
                  ],
                ),
              ),
            ),

            // ── Progress bar (flush below nav row) ───────────────────────
            if (showProgress)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: StepProgressBar(step: step!, total: total!),
              ),
          ],
        ),
      ),
    );
  }
}
