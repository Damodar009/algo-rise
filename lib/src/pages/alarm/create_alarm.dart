import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/alarm_time_picker.dart';
import 'package:algo_rise/src/widgets/repeat_days_selector.dart';
import 'package:algo_rise/src/widgets/alarm_mode_selector.dart';
import 'package:algo_rise/src/widgets/alarm_config_card.dart';
import 'package:algo_rise/src/services/alarm_service.dart';
import 'package:algo_rise/src/models/alarm_data.dart';

class CreateAlarmPage extends StatefulWidget {
  const CreateAlarmPage({super.key});

  @override
  State<CreateAlarmPage> createState() => _CreateAlarmPageState();
}

class _CreateAlarmPageState extends State<CreateAlarmPage> {
  // Selected Time Indices
  late int _selectedHourIndex;
  late int _selectedMinuteIndex;
  late int _selectedPeriodIndex;

  // Repeat Days State [M, T, W, T, F, S, S]
  List<bool> _repeatDays = [false, true, true, true, true, true, false];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final hour = now.hour;
    _selectedHourIndex = (hour % 12 == 0) ? 11 : (hour % 12) - 1;
    _selectedMinuteIndex = now.minute;
    _selectedPeriodIndex = hour >= 12 ? 1 : 0;
  }

  // Mode Selection
  String _activeMode = 'Normal'; // Normal, Strict, Hardcore

  // Config State
  String _challengeType = 'Mixed'; // MCQ, Code, Mixed
  String _language = 'Python'; // Python, JS, Java, C++
  final int _selectedTopicsCount = 3;
  String _difficulty = 'Mix'; // Easy, Med, Hard, Mix
  final String _alarmSound = 'Neon Pulse';

  // Toggle Switches State
  bool _gradualVolume = false;
  bool _vibration = false;
  bool _snooze = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B14),
      appBar: AppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.8),
        elevation: 0,
        title: Text(
          'New Alarm',
          style: AppText.headlineMd.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryFixedDim,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: 20,
            right: -80,
            child: Container(
              key: const ValueKey('decor1'),
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixedDim.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 160,
            left: -80,
            child: Container(
              key: const ValueKey('decor2'),
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Picker Spinner Section
                  Center(
                    child: AlarmTimePicker(
                      initialHourIndex: _selectedHourIndex,
                      initialMinuteIndex: _selectedMinuteIndex,
                      initialPeriodIndex: _selectedPeriodIndex,
                      onChanged: (hIndex, mIndex, pIndex) {
                        setState(() {
                          _selectedHourIndex = hIndex;
                          _selectedMinuteIndex = mIndex;
                          _selectedPeriodIndex = pIndex;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Repeat Days Section
                  RepeatDaysSelector(
                    repeatDays: _repeatDays,
                    onChanged: (newDays) {
                      setState(() => _repeatDays = newDays);
                    },
                  ),
                  const SizedBox(height: 32),

                  // Mode Selector Section
                  AlarmModeSelector(
                    activeMode: _activeMode,
                    onChanged: (newMode) {
                      setState(() => _activeMode = newMode);
                    },
                  ),
                  const SizedBox(height: 32),

                  // Alarm Config Options
                  _buildAlarmConfigSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Floating Save Button at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildSaveButtonContainer(),
          ),
        ],
      ),
    );
  }

  // ─── Alarm Config Section ────────────────────────────────────────────────
  Widget _buildAlarmConfigSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALARM CONFIG',
          style: AppText.labelCaps.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),

        // Challenge Type Card
        AlarmConfigCard(
          title: 'CHALLENGE TYPE',
          child: Row(
            children: ['MCQ', 'Code', 'Mixed'].map((t) {
              final active = _challengeType == t;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(t),
                  selected: active,
                  onSelected: (_) => setState(() => _challengeType = t),
                  selectedColor: AppColors.primaryFixedDim,
                  backgroundColor: Colors.transparent,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: active
                        ? AppColors.onPrimaryFixed
                        : AppColors.onSurfaceVariant,
                  ),
                  side: BorderSide(
                    color: active
                        ? AppColors.primaryFixedDim
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // Language Card
        AlarmConfigCard(
          title: 'LANGUAGE',
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Python', 'JS', 'Java', 'C++'].map((l) {
                final active = _language == l;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(l),
                    selected: active,
                    onSelected: (_) => setState(() => _language = l),
                    selectedColor: AppColors.primaryFixedDim,
                    backgroundColor: Colors.transparent,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      color: active
                          ? AppColors.onPrimaryFixed
                          : AppColors.onSurfaceVariant,
                    ),
                    side: BorderSide(
                      color: active
                          ? AppColors.primaryFixedDim
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Topics Button
        GestureDetector(
          onTap: () {},
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOPICS',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'JetBrains Mono',
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_selectedTopicsCount topics selected',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryFixedDim,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.primaryFixedDim,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Difficulty Card
        AlarmConfigCard(
          title: 'DIFFICULTY',
          child: Row(
            children: ['Easy', 'Med', 'Hard', 'Mix'].map((d) {
              final active = _difficulty == d;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Center(child: Text(d)),
                    selected: active,
                    onSelected: (_) => setState(() => _difficulty = d),
                    selectedColor: active
                        ? Colors.transparent
                        : AppColors.primaryFixedDim,
                    backgroundColor: Colors.transparent,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      color: active
                          ? AppColors.primaryFixedDim
                          : AppColors.onSurfaceVariant,
                    ),
                    side: BorderSide(
                      color: active
                          ? AppColors.primaryFixedDim
                          : Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // Alarm Sound Button
        GestureDetector(
          onTap: () {},
          child: GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ALARM SOUND',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'JetBrains Mono',
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _alarmSound,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryFixedDim,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.music_note, color: AppColors.primaryFixedDim),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Toggles List
        Column(
          children: [
            _buildSwitchRow(
              label: 'Gradual Volume',
              value: _gradualVolume,
              onChanged: (val) => setState(() => _gradualVolume = val),
            ),
            _buildSwitchRow(
              label: 'Vibration',
              value: _vibration,
              onChanged: (val) => setState(() => _vibration = val),
            ),
            _buildSwitchRow(
              label: 'Snooze',
              value: _snooze,
              onChanged: (val) => setState(() => _snooze = val),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF080B14),
            activeTrackColor: AppColors.primaryFixedDim,
            inactiveThumbColor: AppColors.onSurfaceVariant,
            inactiveTrackColor: AppColors.surfaceContainer,
          ),
        ],
      ),
    );
  }

  // ─── Bottom Save Button Container ──────────────────────────────────────────
  Widget _buildSaveButtonContainer() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color(0xFF080B14),
            const Color(0xFF080B14).withValues(alpha: 0.95),
            Colors.transparent,
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          final String hourStr = (_selectedHourIndex + 1).toString().padLeft(
            2,
            '0',
          );
          final String minuteStr = _selectedMinuteIndex.toString().padLeft(
            2,
            '0',
          );
          final String periodStr = _selectedPeriodIndex == 0 ? 'AM' : 'PM';

          final newAlarm = AlarmData(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            time: '$hourStr:$minuteStr',
            period: periodStr,
            repeatDays: List<bool>.from(_repeatDays),
            active: true,
            mode: '${_activeMode.toUpperCase()} MODE',
            language: _challengeType == 'MCQ' ? null : _language,
            tags: _challengeType == 'MCQ' ? [] : ['Arrays'],
            themeColor: _activeMode == 'Hardcore'
                ? const Color(0xFFFF6F00)
                : AppColors.primaryFixedDim,
          );

          AlarmService.instance.addAlarm(newAlarm);
          Navigator.of(context).pop();
        },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primaryFixedDim,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.save, color: AppColors.onPrimaryFixed, size: 24),
              const SizedBox(width: 8),
              Text(
                'Save Alarm',
                style: AppText.headlineMd.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimaryFixed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
