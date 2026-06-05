import 'package:flutter/material.dart';

/// Standard scrollable body used on every onboarding page.
///
/// Wraps [child] in:
///   SingleChildScrollView → Center → ConstrainedBox(maxWidth: [maxWidth])
///
/// Usage:
/// ```dart
/// OnboardingPageBody(
///   child: Column(children: [...]),
/// )
/// ```
class OnboardingPageBody extends StatelessWidget {
  final Widget child;

  /// Max content width. Default 512 matches most onboarding pages.
  final double maxWidth;

  /// Padding. Default leaves room for the floating CTA footer.
  final EdgeInsetsGeometry padding;

  const OnboardingPageBody({
    super.key,
    required this.child,
    this.maxWidth = 512,
    this.padding = const EdgeInsets.fromLTRB(24, 24, 24, 160),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
