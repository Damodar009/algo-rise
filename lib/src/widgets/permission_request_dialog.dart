import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class PermissionRequestDialog extends StatefulWidget {
  const PermissionRequestDialog({super.key});

  /// Checks if any required permissions are missing and prompts the modal dialog.
  static Future<void> showIfNeeded(BuildContext context) async {
    if (!Platform.isAndroid) return;

    final hasNotification = await Permission.notification.isGranted;
    final hasExactAlarm = await Permission.scheduleExactAlarm.isGranted;
    final hasBatteryOpt = await Permission.ignoreBatteryOptimizations.isGranted;
    final hasSystemAlert = await Permission.systemAlertWindow.isGranted;

    if (!hasNotification || !hasExactAlarm || !hasBatteryOpt || !hasSystemAlert) {
      if (context.mounted) {
        await showModalBottomSheet<void>(
          context: context,
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const PermissionRequestDialog(),
        );
      }
    }
  }

  @override
  State<PermissionRequestDialog> createState() => _PermissionRequestDialogState();
}

class _PermissionRequestDialogState extends State<PermissionRequestDialog>
    with WidgetsBindingObserver {
  bool _notificationGranted = false;
  bool _exactAlarmGranted = false;
  bool _batteryOptGranted = false;
  bool _systemAlertGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkStatuses();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkStatuses();
    }
  }

  Future<void> _checkStatuses() async {
    final notification = await Permission.notification.isGranted;
    final exactAlarm = await Permission.scheduleExactAlarm.isGranted;
    final batteryOpt = await Permission.ignoreBatteryOptimizations.isGranted;
    final systemAlert = await Permission.systemAlertWindow.isGranted;

    if (mounted) {
      setState(() {
        _notificationGranted = notification;
        _exactAlarmGranted = exactAlarm;
        _batteryOptGranted = batteryOpt;
        _systemAlertGranted = systemAlert;
      });

      // Auto-dismiss if all permissions are granted
      if (notification && exactAlarm && batteryOpt && systemAlert) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      await permission.request();
    }
    await _checkStatuses();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * 0.9,
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Permissions & Reliability Setup',
            style: AppText.headlineMd.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'AlgoRise needs these permissions to ensure your morning algorithm challenges ring reliably and do not get missed.',
            style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildPermissionItem(
                  icon: Icons.notifications_active_outlined,
                  title: 'Show Notifications',
                  description: 'Required to ring the alarm and display challenge alerts.',
                  isGranted: _notificationGranted,
                  onTap: () => _requestPermission(Permission.notification),
                ),
                _buildPermissionItem(
                  icon: Icons.alarm_on_outlined,
                  title: 'Schedule Exact Alarms',
                  description: 'Ensures the alarm rings precisely on time, even if the phone is asleep.',
                  isGranted: _exactAlarmGranted,
                  onTap: () => _requestPermission(Permission.scheduleExactAlarm),
                ),
                _buildPermissionItem(
                  icon: Icons.battery_saver_outlined,
                  title: 'Disable Battery Optimizations',
                  description: 'Prevents the Android OS from putting the alarm service to sleep.',
                  isGranted: _batteryOptGranted,
                  onTap: () => _requestPermission(Permission.ignoreBatteryOptimizations),
                ),
                _buildPermissionItem(
                  icon: Icons.picture_in_picture_alt_outlined,
                  title: 'Display Over Other Apps',
                  description: 'Displays the fullscreen alarm screen on top of other apps and lock screen.',
                  isGranted: _systemAlertGranted,
                  onTap: () => _requestPermission(Permission.systemAlertWindow),
                ),
                const SizedBox(height: 16),
                _buildBackgroundServiceGuide(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Skip for now',
                    style: AppText.bodyMd.copyWith(color: AppColors.onSurface),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await openAppSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryFixedDim,
                    foregroundColor: AppColors.onPrimaryFixed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'System Settings',
                    style: AppText.bodyMd.copyWith(
                      color: AppColors.onPrimaryFixed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.surfaceContainer,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isGranted
              ? AppColors.tertiaryFixedDim.withValues(alpha: 0.3)
              : AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isGranted ? AppColors.tertiaryFixedDim : AppColors.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppText.bodyMd.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isGranted ? Colors.white : AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: AppText.bodyMd.copyWith(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                isGranted ? Icons.check_circle : Icons.arrow_circle_right_outlined,
                color: isGranted ? AppColors.tertiaryFixedDim : AppColors.primaryFixedDim,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundServiceGuide() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.settings_applications_outlined,
                color: AppColors.primaryFixedDim,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Background Service Guide',
                  style: AppText.bodyMd.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryFixedDim,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'To keep the alarm active in the background, please complete the following steps in System Settings:',
            style: AppText.bodyMd.copyWith(
              fontSize: 13,
              height: 1.4,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          _buildGuideStep('1', 'Tap the "System Settings" button below to open settings.'),
          _buildGuideStep('2', 'Navigate to "Battery" or "App Battery Usage".'),
          _buildGuideStep('3', 'Select "Unrestricted" or "Don\'t Optimize" for AlgoRise.'),
          _buildGuideStep('4', 'If your device has an "Autostart" setting (e.g. Xiaomi, OnePlus), make sure Autostart is enabled.'),
        ],
      ),
    );
  }

  Widget _buildGuideStep(String stepNumber, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Text(
              stepNumber,
              style: AppText.bodyMd.copyWith(
                fontSize: 11,
                height: 1.4,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryFixedDim,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppText.bodyMd.copyWith(
                fontSize: 13,
                height: 1.4,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
