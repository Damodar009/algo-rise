import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';

class NextAlarmHeroCard extends StatefulWidget {
  final String time;
  final String period;
  final String firesIn;
  final List<String> tags;

  const NextAlarmHeroCard({
    super.key,
    required this.time,
    required this.period,
    required this.firesIn,
    this.tags = const [],
  });

  @override
  State<NextAlarmHeroCard> createState() => _NextAlarmHeroCardState();
}

class _NextAlarmHeroCardState extends State<NextAlarmHeroCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseAnim = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, _) {
        final glowAlpha = 0.12 + _pulseAnim.value * 0.06;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withValues(alpha: 0.03),
            border: Border.all(
              color: AppColors.primaryFixedDim.withValues(alpha: 0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryFixedDim.withValues(alpha: glowAlpha),
                blurRadius: 32,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Background watermark icon
                Positioned(
                  top: -16,
                  right: -12,
                  child: Opacity(
                    opacity: 0.07,
                    child: Icon(
                      Icons.alarm,
                      size: 120,
                      color: AppColors.primaryFixedDim,
                    ),
                  ),
                ),
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NEXT ALARM',
                      style: AppText.labelCaps.copyWith(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Time display
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          widget.time,
                          style: AppText.displayMobile.copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryFixedDim,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.period,
                          style: AppText.headlineMd.copyWith(
                            fontSize: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Tags
                    if (widget.tags.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.tags.map((tag) {
                          return _AlarmTag(label: tag);
                        }).toList(),
                      ),
                    const SizedBox(height: 20),
                    // Fires in row
                    Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnim,
                          builder: (_, _) => Opacity(
                            opacity: 0.7 + _pulseAnim.value * 0.3,
                            child: const Icon(
                              Icons.bolt,
                              color: AppColors.primaryFixedDim,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'fires in ${widget.firesIn}',
                          style: AppText.labelCode.copyWith(
                            fontSize: 13,
                            color: AppColors.primaryFixedDim,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AlarmTag extends StatelessWidget {
  final String label;

  const _AlarmTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 11,
          color: AppColors.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
