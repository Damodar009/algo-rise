import 'package:algo_rise/src/pages/home/main_navigation_page.dart';
import 'package:algo_rise/src/pages/onboarding/onboarding_flow.dart';
import 'package:algo_rise/src/pages/alarm/create_alarm.dart';
import 'package:algo_rise/src/pages/alarm/alarm_ringing_page.dart';
import 'package:algo_rise/src/pages/challenge/code_challenge_page.dart';
import 'package:algo_rise/src/pages/login/login_page.dart';
import 'package:algo_rise/src/pages/login/signup_page.dart';
import 'package:algo_rise/src/pages/login/claim_handle_page.dart';
import 'package:algo_rise/src/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Application router.
///
/// Routes:
///   /            → OnboardingFlow (7-step onboarding)
///   /home        → MainNavigationPage
///   /main        → MainNavigationPage
///   /login       → LoginPage
///   /signup      → SignUpPage
///   /claim-handle → ClaimHandlePage
class AppRouter {
  final GoRouter _router;

  GoRouter get router => _router;

  AppRouter({
    required String initialLocation,
    required GlobalKey<NavigatorState> navigatorKey,
    required List<NavigatorObserver> observers,
  }) : _router = GoRouter(
         initialLocation: initialLocation,
         navigatorKey: navigatorKey,
         observers: observers,
         redirect: (context, state) {
           final hasSeenOnboarding = PreferencesService.instance.hasSeenOnboarding;
           final isLoggedIn = PreferencesService.instance.isLoggedIn;
           
           final isRinging = state.matchedLocation == '/alarm/ringing';
           if (isRinging) return null;

           final isOnboarding = state.matchedLocation == '/';
           final isLoggingIn = state.matchedLocation == '/login';
           final isSigningUp = state.matchedLocation == '/signup';

           if (!hasSeenOnboarding) {
             if (!isOnboarding) {
               return '/';
             }
             return null;
           }

           if (!isLoggedIn) {
             if (!isLoggingIn && !isSigningUp) {
               return '/login';
             }
             return null;
           }

           if (isOnboarding || isLoggingIn || isSigningUp) {
             return '/main';
           }

           return null;
         },
         routes: [
           GoRoute(
             path: '/',
             pageBuilder: (context, state) =>
                 _slidePage(state.pageKey, state.path, const OnboardingFlow()),
           ),
           GoRoute(
             path: '/login',
             pageBuilder: (context, state) =>
                 _slidePage(state.pageKey, state.path, const LoginPage()),
           ),
           GoRoute(
             path: '/signup',
             pageBuilder: (context, state) =>
                 _slidePage(state.pageKey, state.path, const SignUpPage()),
           ),
           GoRoute(
             path: '/claim-handle',
             pageBuilder: (context, state) =>
                 _slidePage(state.pageKey, state.path, const ClaimHandlePage()),
           ),
           GoRoute(
             path: '/home',
             pageBuilder: (context, state) => _slidePage(
               state.pageKey,
               state.path,
               const MainNavigationPage(),
             ),
           ),
           GoRoute(
             path: '/main',
             pageBuilder: (context, state) => _slidePage(
               state.pageKey,
               state.path,
               const MainNavigationPage(),
             ),
           ),
           GoRoute(
             path: '/alarm/create',
             pageBuilder: (context, state) =>
                 _slidePage(state.pageKey, state.path, const CreateAlarmPage()),
           ),
           GoRoute(
             path: '/alarm/ringing',
             pageBuilder: (context, state) => _slidePage(
               state.pageKey,
               state.path,
               const AlarmRingingPage(),
             ),
           ),
           GoRoute(
             path: '/challenge',
             pageBuilder: (context, state) => _slidePage(
               state.pageKey,
               state.path,
               const CodeChallengePage(),
             ),
           ),
         ],
       );

  /// Slide-up page transition used for top-level route changes.
  static CustomTransitionPage<void> _slidePage(
    LocalKey key,
    String? name,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: key,
      name: name,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (_, animation, _, c) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: c,
      ),
    );
  }
}
