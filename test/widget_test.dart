import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:algo_rise/src/app.dart';

void main() {
  testWidgets('App loads onboarding page', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    // Build the app and trigger a frame.
    await tester.pumpWidget(
      EasyLocalization(
        path: 'assets/translations',
        useOnlyLangCode: true,
        startLocale: const Locale('en'),
        supportedLocales: const [Locale('en')],
        child: const App(initialRoute: '/'),
      ),
    );
    await tester.pump();
    await tester.idle();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that the onboarding flow is displayed.
    expect(find.text("We'll calibrate your challenges."), findsOneWidget);
  });
}
