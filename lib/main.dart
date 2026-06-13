import 'package:alarm/alarm.dart';
import 'package:algo_rise/src/core/utils/constants.dart';
import 'package:algo_rise/src/services/alarm_service.dart';
import 'package:easy_localization/easy_localization.dart' show EasyLocalization;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/config/app_config.dart';
import 'src/app.dart';
import 'src/core/utils/path_provider.dart';

// Method channel matching MainActivity.kt
const _alarmChannel = MethodChannel('com.example.algo_rise/alarm');

Future<bool> _checkNativeAlarmRinging() async {
  try {
    final bool? result = await _alarmChannel.invokeMethod<bool>('isAlarmRinging');
    return result ?? false;
  } catch (_) {
    // Fallback: use the alarm package's own check
    return Alarm.isRinging();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialises the alarm plugin and calls checkAlarm() which reschedules
  // past-due alarms and updates the Alarm.ringing stream.
  await Alarm.init();
  await AppPathProvider.initPath();
  await AlarmService.instance.loadAlarms();

  // Ask the native side directly: is AlarmService currently running
  // (i.e. did an alarm just fire and launch this app)?
  // This is read from AlarmService.ringingAlarmIds — a static field
  // that is populated BEFORE Flutter even starts.
  final bool alarmCurrentlyRinging = await _checkNativeAlarmRinging();

  debugPrint('[AlgoRise] Alarm ringing on launch: $alarmCurrentlyRinging');

  runApp(
    EasyLocalization(
      path: 'assets/translations',
      useOnlyLangCode: true,
      startLocale: const Locale(Config.locale),
      supportedLocales: AppLocale.locales,
      child: App(
        initialRoute: alarmCurrentlyRinging ? '/alarm/ringing' : '/main',
      ),
    ),
  );
}
