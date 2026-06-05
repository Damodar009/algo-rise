import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';

class AlarmCard extends StatelessWidget {
  final String time;
  final String period;
  final List<bool> repeatDays;
  final bool active;
  final String mode;
  final String? language;
  final List<String> tags;
  final Color themeColor;
  final ValueChanged<bool> onToggle;

  const AlarmCard({
    super.key,
    required this.time,
    required this.period,
    required this.repeatDays,
    required this.active,
    required this.mode,
    required this.language,
    required this.tags,
    required this.themeColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Opacity(
      opacity: active ? 1.0 : 0.6,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active
                ? themeColor.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: themeColor.withValues(alpha: 0.15),
                    blurRadius: 16,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: active ? themeColor : AppColors.onSurfaceVariant,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          period,
                          style: AppText.labelCaps.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(7, (index) {
                        final isSet = repeatDays[index];
                        return Container(
                          width: 26,
                          height: 26,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSet
                                ? (active ? themeColor : AppColors.surfaceContainerHighest)
                                : Colors.transparent,
                            border: isSet
                                ? null
                                : Border.all(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            dayLabels[index],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSet
                                  ? (active ? Colors.black : AppColors.onSurface)
                                  : AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                              fontFamily: 'JetBrains Mono',
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                // Toggle Switch
                GestureDetector(
                  onTap: () => onToggle(!active),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 56,
                    height: 32,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: active ? themeColor : AppColors.surfaceContainerHighest,
                    ),
                    child: Align(
                      alignment: active ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active ? Colors.black : AppColors.outlineVariant,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Text(
                    mode,
                    style: AppText.labelCaps.copyWith(
                      fontSize: 9,
                      color: active ? themeColor : AppColors.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (language != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    height: 16,
                    width: 1,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: active ? themeColor.withValues(alpha: 0.15) : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: active
                            ? themeColor.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Text(
                      language!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: active ? themeColor : AppColors.onSurfaceVariant,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ),
                ],
                for (final tag in tags) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: active ? themeColor.withValues(alpha: 0.15) : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: active
                            ? themeColor.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: active ? themeColor : AppColors.onSurfaceVariant,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
