import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/cta_footer.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/widgets/onboarding_header.dart';
import 'package:algo_rise/src/widgets/onboarding_page_body.dart';
import 'package:algo_rise/src/widgets/onboarding_scaffold.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:flutter/material.dart';

class WhenIsInterviewPage extends StatefulWidget {
  final VoidCallback? onNext;

  const WhenIsInterviewPage({super.key, this.onNext});

  @override
  State<WhenIsInterviewPage> createState() => _WhenIsInterviewPageState();
}

class _WhenIsInterviewPageState extends State<WhenIsInterviewPage>
    with SingleTickerProviderStateMixin {
  late DateTime _currentMonthYear;
  DateTime? _selectedDate;
  int _daysPerWeek = 4;

  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    // Default calendar view is current month
    final now = DateTime.now();
    _currentMonthYear = DateTime(now.year, now.month);
    // Pre-select date to be 6 weeks (42 days) from now, just like mockup nudge
    _selectedDate = now.add(const Duration(days: 42));

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _prevMonth() {
    setState(() {
      _currentMonthYear = DateTime(
        _currentMonthYear.year,
        _currentMonthYear.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonthYear = DateTime(
        _currentMonthYear.year,
        _currentMonthYear.month + 1,
      );
    });
  }

  int get _weeksRemaining {
    if (_selectedDate == null) return 0;
    final diff = _selectedDate!.difference(DateTime.now()).inDays;
    return (diff / 7).ceil().clamp(0, 52);
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: const OnboardingHeader(step: 8, total: 11),
      body: OnboardingPageBody(
        maxWidth: 1024,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 768;
            
            // Left Column: Date Selection
            final leftColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('When is your interview?', style: AppText.displayMobile),
                const SizedBox(height: 8),
                Text(
                  'Setting a target date helps us prioritize the most frequent problem patterns for your remaining time.',
                  style: AppText.bodyLg,
                ),
                const SizedBox(height: 24),
                
                // Calendar Card
                _buildCalendarCard(),
                const SizedBox(height: 16),
                
                // Dynamic Nudge Banner
                if (_selectedDate != null) _buildNudgeBanner(),
              ],
            );

            // Right Column: Study Pace & Aesthetics
            final rightColumn = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How many days a week can you study?',
                  style: AppText.headlineMd,
                ),
                const SizedBox(height: 24),
                
                // Pace Slider Card
                _buildPaceSliderCard(),
                const SizedBox(height: 24),
                
                // Visual Code Atmosphere Card
                _buildVisualCodeCard(),
              ],
            );

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: leftColumn),
                  const SizedBox(width: 32),
                  Expanded(flex: 5, child: rightColumn),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  leftColumn,
                  const SizedBox(height: 40),
                  rightColumn,
                  const SizedBox(height: 24),
                ],
              );
            }
          },
        ),
      ),
      cta: CtaFooter(
        button: NeonCtaButton(
          label: 'Set Schedule',
          height: 64,
          pulseAnim: _pulseAnim,
          onTap: widget.onNext,
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    final year = _currentMonthYear.year;
    final month = _currentMonthYear.month;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final firstDayOffset = DateTime(year, month, 1).weekday % 7;
    
    // Total items in grid = offset + days in month
    final totalGridItems = firstDayOffset + daysInMonth;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getMonthName(month)} $year',
                style: AppText.headlineMd.copyWith(color: AppColors.primary),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _prevMonth,
                    icon: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.outlineVariant),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.outlineVariant),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Weekday Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _WeekdayLabel('S'), _WeekdayLabel('M'), _WeekdayLabel('T'),
              _WeekdayLabel('W'), _WeekdayLabel('T'), _WeekdayLabel('F'),
              _WeekdayLabel('S'),
            ],
          ),
          const SizedBox(height: 8),
          
          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: totalGridItems,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) {
                // Empty slots for previous month offset
                return const SizedBox.shrink();
              }
              
              final dayNum = index - firstDayOffset + 1;
              final cellDate = DateTime(year, month, dayNum);
              final isSelected = _selectedDate != null &&
                  _selectedDate!.year == cellDate.year &&
                  _selectedDate!.month == cellDate.month &&
                  _selectedDate!.day == cellDate.day;

              return Pressable(
                onTap: () {
                  setState(() {
                    _selectedDate = cellDate;
                  });
                },
                scaleDown: 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(color: AppColors.primaryFixed, width: 1)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$dayNum',
                    style: AppText.bodyMd.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? AppColors.onPrimaryFixed
                          : AppColors.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNudgeBanner() {
    final weeks = _weeksRemaining;
    final message = weeks > 0
        ? 'That gives us $weeks weeks — we\'ll pace accordingly.'
        : 'Target date set — we\'ll customize your schedule.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          left: BorderSide(color: AppColors.secondary, width: 4),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_available, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppText.bodyMd.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaceSliderCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$_daysPerWeek',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryFixedDim,
                ),
              ),
              Text(
                'DAYS / WEEK',
                style: AppText.labelCaps.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Custom Styled Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: AppColors.primaryFixedDim,
              inactiveTrackColor: AppColors.surfaceContainerHighest,
              thumbColor: AppColors.primaryFixedDim,
              overlayColor: AppColors.primaryFixedDim.withOpacity(0.2),
              valueIndicatorTextStyle: AppText.labelCaps,
            ),
            child: Slider(
              value: _daysPerWeek.toDouble(),
              min: 2,
              max: 7,
              divisions: 5,
              label: '$_daysPerWeek days',
              onChanged: (val) {
                setState(() {
                  _daysPerWeek = val.round();
                });
              },
            ),
          ),
          
          // Slider tick labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) {
                final tickVal = i + 2;
                return Text(
                  '$tickVal',
                  style: AppText.labelCaps.copyWith(
                    color: _daysPerWeek == tickVal
                        ? AppColors.primaryFixedDim
                        : AppColors.onSurfaceVariant.withOpacity(0.5),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            '"We recommend at least 3 days for consistent retention."',
            style: AppText.bodyMd.copyWith(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualCodeCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Text(
              '// STUDY_PACE_PROTOCOL',
              style: AppText.labelCode.copyWith(
                color: AppColors.primaryFixedDim,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'pace = studyDays >= 3 ? "optimal" : "slow";',
              textAlign: TextAlign.center,
              style: AppText.labelCode.copyWith(
                fontSize: 11,
                color: AppColors.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'if (weeksRemaining <= 6) { focus = "high_freq_patterns"; }',
              textAlign: TextAlign.center,
              style: AppText.labelCode.copyWith(
                fontSize: 11,
                color: AppColors.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String label;
  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppText.labelCaps.copyWith(
          color: AppColors.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
