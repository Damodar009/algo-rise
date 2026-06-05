import 'package:algo_rise/src/config/routes/app_routes.dart';
import 'package:algo_rise/src/config/themes/app_theme.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/core/theme/theme_scope.dart';
import 'package:algo_rise/src/services/preferences_service.dart';
import 'package:easy_localization/easy_localization.dart'
    show BuildContextEasyLocalizationExtension, tr;
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

final mainNavigator = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class App extends StatefulWidget {
  static void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  AppRouter? _router;
  ThemeMode _themeMode = ThemeMode.dark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Import preferences service at top of file
    final prefsService = await PreferencesService.create();

    // Determine initial route. For now, use the placeholder root route.
    // TODO: Update to proper onboarding/auth routes when they are added.
    const String initialLocation = '/main';

    setState(() {
      _router = AppRouter(
        initialLocation: initialLocation,
        navigatorKey: mainNavigator,
        observers: [routeObserver],
      );
    });
  }

  @override
  void dispose() {
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
