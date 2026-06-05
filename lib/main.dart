import 'package:alarm/alarm.dart';
import 'package:algo_rise/src/core/utils/constants.dart';
import 'package:algo_rise/src/services/alarm_service.dart';
import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:flutter/material.dart';

import 'src/config/app_config.dart';
import 'src/app.dart';
import 'src/core/utils/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  // await Firebase.initializeApp();
  await AppPathProvider.initPath();
  await AlarmService.instance.loadAlarms();

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      useOnlyLangCode: true,
      startLocale: const Locale(Config.locale),
      supportedLocales: AppLocale.locales,
      child: const App(),
    ),
  );
}

