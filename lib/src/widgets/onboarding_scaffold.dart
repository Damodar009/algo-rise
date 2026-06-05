import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class OnboardingScaffold extends StatelessWidget {
  final Widget header;
  final double headerHeight; // how much to push body down
  final Widget body;
  final Widget cta;

  const OnboardingScaffold({
    super.key,
    required this.header,
    required this.headerHeight,
    required this.body,
    required this.cta,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: header),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: headerHeight),
              child: body,
            ),
          ),
          Positioned(bottom: 0, left: 0, right: 0, child: cta),
        ],
      ),
    );
  }
}
