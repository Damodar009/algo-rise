import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:algo_rise/src/config/routes/app_routes.dart';
import 'package:algo_rise/src/config/themes/app_theme.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/core/theme/theme_scope.dart';
import 'package:algo_rise/src/services/preferences_service.dart';
import 'package:easy_localization/easy_localization.dart'
    show BuildContextEasyLocalizationExtension, tr;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

final mainNavigator = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class App extends StatefulWidget {
  /// The initial route determined in main() after Alarm.init() completes.
  /// Either '/main' or '/alarm/ringing' if an alarm is currently ringing.
  final String initialRoute;

  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  const App({super.key, required this.initialRoute});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  AppRouter? _router;
  ThemeMode _themeMode = ThemeMode.dark;
  StreamSubscription<AlarmSet>? _alarmRingSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();

    // ──────────────────────────────────────────────────────────────────────
    // Foreground listener: when an alarm fires while the app is ALREADY open,
    // navigate to the ringing screen immediately.
    // For cold-start (app killed / screen off), the initialRoute passed from
    // main() handles navigation before the widget tree is built.
    // ──────────────────────────────────────────────────────────────────────
    _alarmRingSubscription = Alarm.ringing.listen((alarmSet) {
      if (alarmSet.alarms.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = mainNavigator.currentContext;
          if (ctx != null && ctx.mounted) {
            GoRouter.of(ctx).go('/alarm/ringing');
          }
        });
      }
    });
  }

  Future<void> _initializeApp() async {
    await PreferencesService.create();

    setState(() {
      _router = AppRouter(
        // initialRoute is already resolved correctly in main() before runApp()
        initialLocation: widget.initialRoute,
        navigatorKey: mainNavigator,
        observers: [routeObserver],
      );
    });
  }

  @override
  void dispose() {
    _alarmRingSubscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (_, orientation, deviceType) {
        if (_router == null) {
          return MaterialApp(
            theme: AppTheme.dark,
            home: Scaffold(
              backgroundColor: AppColors.background,
              body: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryFixedDim,
                ),
              ),
            ),
          );
        }
        return ThemeScope(
          mode: _themeMode,
          toggleTheme: _toggleTheme,
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: MaterialApp.router(
              locale: context.locale,
              routerConfig: _router!.router,
              title: tr("Black Hawk"),
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: _themeMode,
              supportedLocales: context.supportedLocales,
            ),
          ),
        );
      },
    );
  }

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }
}
