import 'package:flutter/material.dart';

class ThemeScope extends InheritedWidget {
  final ThemeMode mode;
  final VoidCallback toggleTheme;

  const ThemeScope({
    super.key,
    required this.mode,
    required this.toggleTheme,
    required super.child,
  });

  static ThemeScope of(BuildContext context) {
    final ThemeScope? result =
        context.dependOnInheritedWidgetOfExactType<ThemeScope>();
    assert(result != null, 'ThemeScope not found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant ThemeScope oldWidget) {
    return oldWidget.mode != mode;
  }
}
