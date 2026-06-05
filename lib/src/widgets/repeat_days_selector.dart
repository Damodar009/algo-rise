import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';

class RepeatDaysSelector extends StatefulWidget {
  final List<bool> repeatDays;
  final ValueChanged<List<bool>> onChanged;

  const RepeatDaysSelector({
    super.key,
    required this.repeatDays,
    required this.onChanged,
  });

  @override
  State<RepeatDaysSelector> createState() => _RepeatDaysSelectorState();
}

class _RepeatDaysSelectorState extends State<RepeatDaysSelector> {
  late List<bool> _repeatDays;
  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    _repeatDays = List.from(widget.repeatDays);
  }

  @override
  void didUpdateWidget(covariant RepeatDaysSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.repeatDays != oldWidget.repeatDays) {
      _repeatDays = List.from(widget.repeatDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REPEAT',
          style: AppText.labelCaps.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final active = _repeatDays[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _repeatDays[index] = !_repeatDays[index];
                });
                widget.onChanged(List.from(_repeatDays));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? AppColors.primaryFixedDim
                      : Colors.white.withValues(alpha: 0.04),
                  border: Border.all(
                    color: active
                        ? AppColors.primaryFixedDim
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: AppColors.primaryFixedDim.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  _dayLabels[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: active
                        ? AppColors.onPrimaryFixed
                        : AppColors.onSurfaceVariant,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
