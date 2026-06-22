import 'package:algo_rise/src/pages/onboarding/challenge_type.dart';
import 'package:algo_rise/src/pages/onboarding/knowledge_level_page.dart';
import 'package:algo_rise/src/pages/onboarding/launguage_selection.dart';
import 'package:algo_rise/src/pages/onboarding/topic_selection.dart';
import 'package:algo_rise/src/pages/onboarding/wake_intensity.dart';
import 'package:algo_rise/src/pages/onboarding/waking_up.dart';
import 'package:algo_rise/src/pages/onboarding/why_are_you_here.dart';
import 'package:algo_rise/src/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Drives all 7 onboarding pages with slide-in/out transitions.
///
/// Manages its own [PageController] so back/forward taps move between steps
/// without touching the app-level router. When the user completes step 7,
/// [onFinish] is called — the caller is responsible for navigating to `/home`.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final _pageController = PageController();
  int _currentPage = 0;
  static const int _totalPages = 7;

  void _next() async {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      // Finished all 7 steps → mark onboarding seen and navigate to login
      await PreferencesService.instance.setOnboardingSeen();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  void _back() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Override the system back button to go to previous page
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (_currentPage > 0) _back();
      },
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // nav only via buttons
        onPageChanged: (i) => setState(() => _currentPage = i),
        children: [
          KnowledgeLevelPage(onNext: _next),
          ChallengeTypePage(onNext: _next),
          LanguageSelectionPage(onNext: _next),
          TopicSelectionPage(onNext: _next),
          WakeIntensityPage(onNext: _next),
          WhyAreYouHerePage(onNext: _next),
          WhoIsWakingUpPage(onFinish: _next),
        ],
      ),
    );
  }
}
