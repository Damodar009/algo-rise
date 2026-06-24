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

class PlanConfirmationPage extends StatefulWidget {
  final VoidCallback? onNext;

  const PlanConfirmationPage({super.key, this.onNext});

  @override
  State<PlanConfirmationPage> createState() => _PlanConfirmationPageState();
}

class _PlanConfirmationPageState extends State<PlanConfirmationPage>
    with SingleTickerProviderStateMixin {
  int _hour = 8;
  int _minute = 30;
  String _period = 'AM';

  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
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

  void _incrementHour() {
    setState(() {
      _hour = _hour == 12 ? 1 : _hour + 1;
    });
  }

  void _decrementHour() {
    setState(() {
      _hour = _hour == 1 ? 12 : _hour - 1;
    });
  }

  void _incrementMinute() {
    setState(() {
      _minute = (_minute + 1) % 60;
    });
  }

  void _decrementMinute() {
    setState(() {
      _minute = (_minute - 1 + 60) % 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: const OnboardingHeader(step: 10, total: 11),
      body: OnboardingPageBody(
        maxWidth: 1024,
        child: Column(
          children: [
            // Success Visual Banner
            _buildVisualBanner(),
            const SizedBox(height: 32),

            // Bento Columns
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 768;

                final summaryColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(),
                    const SizedBox(height: 16),
                    _buildQuoteCard(),
                  ],
                );

                final alarmColumn = _buildAlarmSetupCard();

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(flex: 5, child: summaryColumn),
                      const SizedBox(width: 24),
                      Expanded(flex: 7, child: alarmColumn),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      summaryColumn,
                      const SizedBox(height: 24),
                      alarmColumn,
                    ],
                  );
                }
              },
            ),
            
            // Decorative dots/visual accent at the bottom
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 32,
                  height: 2,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      cta: CtaFooter(
        button: NeonCtaButton(
          label: 'Start Learning',
          height: 64,
          pulseAnim: _pulseAnim,
          onTap: widget.onNext,
        ),
      ),
    );
  }

  Widget _buildVisualBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Plan Saved.',
            style: AppText.displayMobile.copyWith(color: AppColors.primary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Your roadmap to mastery is ready.',
            style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELECTED CURRICULUM',
            style: AppText.labelCaps.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '8 Weeks • 3 problems/day • Arrays',
            style: AppText.headlineMd.copyWith(
              color: AppColors.primary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.verified,
                color: AppColors.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'We\'ll mix in review problems from earlier weeks automatically — you don\'t need to do anything extra.',
                  style: AppText.bodyMd.copyWith(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryFixedDim.withOpacity(0.05),
        border: const Border(
          left: BorderSide(color: AppColors.primaryFixedDim, width: 4),
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Text(
        '"Consistency is the quiet engine of technical excellence."',
        style: AppText.bodyMd.copyWith(
          fontStyle: FontStyle.italic,
          color: AppColors.primary,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildAlarmSetupCard() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DAILY RITUAL',
                style: AppText.labelCaps.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set your first alarm',
                style: AppText.headlineMd.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),
              
              // Time Picker Widget
              _buildTimePicker(),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  const Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'We\'ll notify you when it\'s time to start. Focus remains yours.',
                      style: AppText.bodyMd.copyWith(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'STATUS: LOCKED IN',
                  style: AppText.labelCaps.copyWith(
                    color: AppColors.secondary,
                    fontSize: 10,
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.bolt,
                      color: AppColors.secondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'First topic unlocks now.',
                      style: AppText.bodyMd.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hour Picker
          _buildTimeDigitColumn(
            value: _hour.toString().padLeft(2, '0'),
            onIncrement: _incrementHour,
            onDecrement: _decrementHour,
          ),
          
          // Colon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              ':',
              style: AppText.displayMobile.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Minute Picker
          _buildTimeDigitColumn(
            value: _minute.toString().padLeft(2, '0'),
            onIncrement: _incrementMinute,
            onDecrement: _decrementMinute,
          ),
          
          const SizedBox(width: 24),
          
          // AM/PM Toggle
          Column(
            children: [
              _buildPeriodButton('AM'),
              const SizedBox(height: 8),
              _buildPeriodButton('PM'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDigitColumn({
    required String value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.expand_less),
          color: AppColors.onSurfaceVariant,
          iconSize: 28,
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.expand_more),
          color: AppColors.onSurfaceVariant,
          iconSize: 28,
        ),
      ],
    );
  }

  Widget _buildPeriodButton(String label) {
    final isSelected = _period == label;
    return Pressable(
      onTap: () {
        setState(() {
          _period = label;
        });
      },
      scaleDown: 0.9,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppText.labelCaps.copyWith(
            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
