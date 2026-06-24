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

// ─── Option Data Model ─────────────────────────────────────────────────────────
class _OptionData {
  final String value;
  final IconData icon;
  final String? badge;
  final String title;
  final String subtitle;

  const _OptionData({
    required this.value,
    required this.icon,
    this.badge,
    required this.title,
    required this.subtitle,
  });
}

const _optionsList = [
  _OptionData(
    value: 'interview',
    icon: Icons.event_note_outlined,
    badge: 'High Intensity',
    title: 'Preparing for a job/interview',
    subtitle:
        'Accelerated path with a focus on competitive problem solving and deadline tracking.',
  ),
  _OptionData(
    value: 'college',
    icon: Icons.account_balance_outlined,
    title: 'Learning DSA for college/exams',
    subtitle:
        'Focus on structural theory, fundamental proofs, and academic requirements.',
  ),
  _OptionData(
    value: 'gradual',
    icon: Icons.self_improvement_outlined,
    badge: 'Flexibility',
    title: 'Learning gradually, no rush',
    subtitle:
        'A relaxed, curiosity-driven approach with no strict deadlines or pressure.',
  ),
  _OptionData(
    value: 'refresh',
    icon: Icons.history_outlined,
    title: 'Refreshing skills I already have',
    subtitle:
        'Focus on review, targeted problem sets, and quick skill validation.',
  ),
];

// ─── Page 6: Why Are You Here ─────────────────────────────────────────────────
class WhyAreYouHerePage extends StatefulWidget {
  final VoidCallback? onNext;

  const WhyAreYouHerePage({super.key, this.onNext});

  @override
  State<WhyAreYouHerePage> createState() => _WhyAreYouHerePageState();
}

class _WhyAreYouHerePageState extends State<WhyAreYouHerePage>
    with SingleTickerProviderStateMixin {
  String? _selectedOption;
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

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: const OnboardingHeader(step: 7, total: 11),
      body: OnboardingPageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Why are you here?', style: AppText.displayMobile),
            const SizedBox(height: 8),
            Text(
              'This helps us tailor your study plan and pace.',
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 32),

            // Bento-ish responsive grid/column
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                if (isWide) {
                  final cardWidth = (constraints.maxWidth - 16) / 2;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: _optionsList.map((opt) {
                      return SizedBox(
                        width: cardWidth,
                        child: _SelectionCard(
                          option: opt,
                          isActive: _selectedOption == opt.value,
                          onTap: () {
                            setState(() {
                              _selectedOption = opt.value;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Column(
                    children: _optionsList.map((opt) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _SelectionCard(
                          option: opt,
                          isActive: _selectedOption == opt.value,
                          onTap: () {
                            setState(() {
                              _selectedOption = opt.value;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      cta: CtaFooter(
        button: NeonCtaButton(
          label: 'Continue',
          height: 64,
          enabled: _selectedOption != null,
          pulseAnim: _pulseAnim,
          onTap: widget.onNext,
        ),
      ),
    );
  }
}

// ─── Selection Card Component ──────────────────────────────────────────────────
class _SelectionCard extends StatefulWidget {
  final _OptionData option;
  final bool isActive;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.option,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<_SelectionCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final opt = widget.option;
    final active = widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Pressable(
        onTap: widget.onTap,
        scaleDown: 0.98,
        child: GlassCard(
          isActive: active,
          activeColor: AppColors.primaryFixedDim,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Badge Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    opt.icon,
                    size: 24,
                    color: (active || _hovered)
                        ? AppColors.primaryFixedDim
                        : AppColors.onSurfaceVariant,
                  ),
                  if (opt.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: opt.value == 'interview'
                            ? AppColors.secondary.withOpacity(0.15)
                            : AppColors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        opt.badge!,
                        style: AppText.labelCaps.copyWith(
                          fontSize: 10,
                          color: opt.value == 'interview'
                              ? AppColors.secondary
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                opt.title,
                style: AppText.bodyLg.copyWith(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w600,
                  color: (active || _hovered)
                      ? AppColors.primary
                      : AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                opt.subtitle,
                style: AppText.bodyMd.copyWith(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
