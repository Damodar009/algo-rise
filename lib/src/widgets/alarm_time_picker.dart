import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/colors.dart';

class AlarmTimePicker extends StatefulWidget {
  final int initialHourIndex;
  final int initialMinuteIndex;
  final int initialPeriodIndex;
  final void Function(int hourIndex, int minuteIndex, int periodIndex) onChanged;

  const AlarmTimePicker({
    super.key,
    required this.initialHourIndex,
    required this.initialMinuteIndex,
    required this.initialPeriodIndex,
    required this.onChanged,
  });

  @override
  State<AlarmTimePicker> createState() => _AlarmTimePickerState();
}

class _AlarmTimePickerState extends State<AlarmTimePicker> {
  late final FixedExtentScrollController _hourController;
  late final FixedExtentScrollController _minuteController;
  late final FixedExtentScrollController _periodController;

  late int _selectedHourIndex;
  late int _selectedMinuteIndex;
  late int _selectedPeriodIndex;

  final List<String> _hours = List.generate(
    12,
    (index) => (index + 1).toString().padLeft(2, '0'),
  );
  final List<String> _minutes = List.generate(
    60,
    (index) => index.toString().padLeft(2, '0'),
  );
  final List<String> _periods = ['AM', 'PM'];

  @override
  void initState() {
    super.initState();
    _selectedHourIndex = widget.initialHourIndex;
    _selectedMinuteIndex = widget.initialMinuteIndex;
    _selectedPeriodIndex = widget.initialPeriodIndex;

    _hourController = FixedExtentScrollController(
      initialItem: _selectedHourIndex,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinuteIndex,
    );
    _periodController = FixedExtentScrollController(
      initialItem: _selectedPeriodIndex,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged(
      _selectedHourIndex,
      _selectedMinuteIndex,
      _selectedPeriodIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Selection Highlight Indicator (Center row overlay)
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryFixedDim.withValues(alpha: 0.05),
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
            ),
          ),
          // Cyan neon glow bar at the bottom of selection indicator
          Positioned(
            bottom: 72,
            left: 35,
            right: 35,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.primaryFixedDim,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),

          // Scroll Wheels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Hours Wheel
              Expanded(
                child: _buildWheel(
                  controller: _hourController,
                  items: _hours,
                  selectedIndex: _selectedHourIndex,
                  onChanged: (val) {
                    setState(() => _selectedHourIndex = val);
                    _notifyChange();
                  },
                ),
              ),
              Text(
                ':',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryFixedDim,
                ),
              ),
              // Minutes Wheel
              Expanded(
                child: _buildWheel(
                  controller: _minuteController,
                  items: _minutes,
                  selectedIndex: _selectedMinuteIndex,
                  onChanged: (val) {
                    setState(() => _selectedMinuteIndex = val);
                    _notifyChange();
                  },
                ),
              ),
              // AM/PM Wheel
              Expanded(
                child: _buildWheel(
                  controller: _periodController,
                  items: _periods,
                  selectedIndex: _selectedPeriodIndex,
                  onChanged: (val) {
                    setState(() => _selectedPeriodIndex = val);
                    _notifyChange();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWheel({
    required FixedExtentScrollController controller,
    required List<String> items,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 50,
      physics: const FixedExtentScrollPhysics(),
      overAndUnderCenterOpacity: 0.4,
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: items.length,
        builder: (context, index) {
          final isSelected = index == selectedIndex;
          return Center(
            child: Text(
              items[index],
              style: isSelected
                  ? TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryFixedDim,
                      fontFamily: 'JetBrains Mono',
                    )
                  : const TextStyle(
                      fontSize: 24,
                      color: AppColors.onSurfaceVariant,
                      fontFamily: 'JetBrains Mono',
                    ),
            ),
          );
        },
      ),
    );
  }
}
