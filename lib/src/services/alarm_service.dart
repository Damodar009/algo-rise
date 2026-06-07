import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:algo_rise/src/models/alarm_data.dart';

class AlarmService {
  static const String _storageKey = 'algo_rise_saved_alarms';

  // Singleton pattern
  AlarmService._privateConstructor();
  static final AlarmService instance = AlarmService._privateConstructor();

  // ValueNotifier containing the list of alarms
  final ValueNotifier<List<AlarmData>> alarmsNotifier =
      ValueNotifier<List<AlarmData>>([]);

  // Get current list of alarms
  List<AlarmData> get alarms => alarmsNotifier.value;

  bool _isLoaded = false;

  // Load alarms from SharedPreferences
  Future<void> loadAlarms({bool force = false}) async {
    if (_isLoaded && !force) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? alarmsJson = prefs.getString(_storageKey);
      if (alarmsJson != null) {
        final List<dynamic> decoded = jsonDecode(alarmsJson);
        final List<AlarmData> loaded = decoded
            .map((item) => AlarmData.fromJson(item as Map<String, dynamic>))
            .toList();
        alarmsNotifier.value = loaded;

        // Sync native alarms schedules
        for (final alarm in loaded) {
          if (alarm.active) {
            await _scheduleNativeAlarm(alarm);
          } else {
            await _unscheduleNativeAlarm(alarm.id);
          }
        }
      }
      _isLoaded = true;
    } catch (e) {
      debugPrint('Error loading/syncing alarms: $e');
    }
  }

  // Save alarms to SharedPreferences
  Future<void> saveAlarms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> encoded = alarmsNotifier.value
          .map((alarm) => alarm.toJson())
          .toList();
      await prefs.setString(_storageKey, jsonEncode(encoded));
    } catch (e) {
      debugPrint('Error saving alarms: $e');
    }
  }

  // Request native permissions for exact alarms and power modes
  Future<bool> checkAndRequestPermissions() async {
    if (Platform.isAndroid) {
      // 1. Post Notifications Permission (Android 13+)
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }

      // 2. Schedule Exact Alarm (Android 12+)
      if (!await Alarm.hasExactAlarmPermission()) {
        await Alarm.requestExactAlarmPermission();
      }

      // 3. Request ignoring battery optimizations
      if (!await Alarm.isBatteryOptimizationIgnored()) {
        await Alarm.requestBatteryOptimizationExemption();
      }

      // 4. Request system alert window (Draw over other apps / display over other apps)
      if (await Permission.systemAlertWindow.isDenied) {
        await Permission.systemAlertWindow.request();
      }
    }
    return true;
  }

  // Helper: Convert string timestamp ID to unique 32-bit int for native SDK
  int _getNativeAlarmId(String id) {
    final parsed = int.tryParse(id);
    if (parsed != null) {
      return parsed % 1000000000;
    }
    return id.hashCode;
  }

  // Helper: Calculate next DateTime trigger for repeating/one-shot alarms
  DateTime _getNextDateTime(String time, String period, List<bool> repeatDays) {
    final now = DateTime.now();
    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If scheduled time is in the past, add 1 day initially
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final hasRepeat = repeatDays.any((d) => d);
    if (hasRepeat) {
      int daysUntil = 0;
      while (daysUntil < 8) {
        final checkDate = scheduledDate.add(Duration(days: daysUntil));
        final weekdayIndex =
            checkDate.weekday - 1; // weekday: 1 (Mon) - 7 (Sun)
        if (repeatDays[weekdayIndex]) {
          if (checkDate.isAfter(now)) {
            scheduledDate = checkDate;
            break;
          }
        }
        daysUntil++;
      }
    }

    return scheduledDate;
  }

  // Schedule native alarm
  Future<void> _scheduleNativeAlarm(AlarmData alarm) async {
    if (!alarm.active) return;

    await checkAndRequestPermissions();

    final scheduledDateTime = _getNextDateTime(
      alarm.time,
      alarm.period,
      alarm.repeatDays,
    );
    final nativeId = _getNativeAlarmId(alarm.id);

    final alarmSettings = AlarmSettings(
      id: nativeId,
      dateTime: scheduledDateTime,
      assetAudioPath: null,
      loopAudio: true,
      vibrate: true,
      volumeSettings: VolumeSettings.fade(
        volume: 0.8,
        fadeDuration: const Duration(seconds: 3),
      ),
      androidFullScreenIntent: true,
      warningNotificationOnKill: true,
      notificationSettings: NotificationSettings(
        title: 'AlgoRise Alarm (${alarm.time} ${alarm.period})',
        body: 'Time to solve your daily algorithm challenge!',
        stopButton: 'Stop',
      ),
    );

    try {
      await Alarm.set(alarmSettings: alarmSettings);
      debugPrint(
        'Successfully scheduled native alarm $nativeId for $scheduledDateTime',
      );
    } catch (e) {
      debugPrint('Error scheduling native alarm: $e');
    }
  }

  // Cancel native alarm
  Future<void> _unscheduleNativeAlarm(String id) async {
    final nativeId = _getNativeAlarmId(id);
    try {
      await Alarm.stop(nativeId);
      debugPrint('Successfully stopped native alarm $nativeId');
    } catch (e) {
      debugPrint('Error stopping native alarm: $e');
    }
  }

  // Add a new alarm
  Future<void> addAlarm(AlarmData alarm) async {
    await loadAlarms(); // Ensure existing alarms are loaded first
    final updatedList = List<AlarmData>.from(alarmsNotifier.value)..add(alarm);
    alarmsNotifier.value = updatedList;
    await saveAlarms();
    await _scheduleNativeAlarm(alarm);
  }

  // Remove an alarm
  Future<void> removeAlarm(String id) async {
    await loadAlarms(); // Ensure existing alarms are loaded first
    final updatedList = List<AlarmData>.from(alarmsNotifier.value)
      ..removeWhere((alarm) => alarm.id == id);
    alarmsNotifier.value = updatedList;
    await saveAlarms();
    await _unscheduleNativeAlarm(id);
  }

  // Toggle alarm active state
  Future<void> toggleAlarmActive(String id, bool active) async {
    await loadAlarms(); // Ensure existing alarms are loaded first
    final updatedList = List<AlarmData>.from(
      alarmsNotifier.value.map((alarm) {
        if (alarm.id == id) {
          alarm.active = active;
        }
        return alarm;
      }),
    );
    alarmsNotifier.value = updatedList;
    await saveAlarms();

    if (active) {
      final alarm = updatedList.firstWhere((alarm) => alarm.id == id);
      await _scheduleNativeAlarm(alarm);
    } else {
      await _unscheduleNativeAlarm(id);
    }
  }
}
