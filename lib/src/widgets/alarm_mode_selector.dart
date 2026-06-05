import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class AlarmModeSelector extends StatefulWidget {
  final String activeMode;
  final ValueChanged<String> onChanged;

  const AlarmModeSelector({
    super.key,
    required this.activeMode,
    required this.onChanged,
  });

  @override
  State<AlarmModeSelector> createState() => _AlarmModeSelectorState();
}

class _AlarmModeSelectorState extends State<AlarmModeSelector> {
  late String _activeMode;
  final List<String> _modes = ['Normal', 'Strict', 'Hardcore'];

  @override
  void initState() {
    super.initState();
    _activeMode = widget.activeMode;
  }

  @override
  void didUpdateWidget(covariant AlarmModeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeMode != oldWidget.activeMode) {
      _activeMode = widget.activeMode;
    }
  }

  String _getModeDescription() {
    switch (_activeMode) {
      case 'Normal':
        return 'One snooze allowed. Hints available. Fallback to MCQ after 3 failed code attempts.';
      case 'Strict':
        return 'No snooze allowed. Limited hints. Fails instantly on wrong code answer.';
      case 'Hardcore':
        return 'No snooze, no hints, maximum volume immediately, and code test failure locks device for 10 minutes.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: _modes.map((m) {
              final active = _activeMode == m;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _activeMode = m);
                    widget.onChanged(m);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.surfaceContainerHighest
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      m,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        color: active
                            ? AppColors.primaryFixedDim
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        // Mode Info Card
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primaryFixedDim,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_activeMode.toUpperCase()} MODE ACTIVE',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryFixedDim,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _getModeDescription(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
