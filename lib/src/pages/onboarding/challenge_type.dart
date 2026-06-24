import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/cta_footer.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/icon_box.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/widgets/onboarding_header.dart';
import 'package:algo_rise/src/widgets/onboarding_page_body.dart';
import 'package:algo_rise/src/widgets/onboarding_scaffold.dart';
import 'package:algo_rise/src/widgets/option_badge.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:flutter/material.dart';

// ─── Page 2: Challenge Type ───────────────────────────────────────────────────
class ChallengeTypePage extends StatefulWidget {
  final VoidCallback? onNext;

  const ChallengeTypePage({super.key, this.onNext});

  @override
  State<ChallengeTypePage> createState() => _ChallengeTypePageState();
}

class _ChallengeTypePageState extends State<ChallengeTypePage> {
  String _selected = 'mixed';

  static const _options = [
    _ChallengeOption(
      id: 'mcq',
      title: 'MCQ + Logic',
      badge: 'FASTEST',
      badgeActive: false,
      desc: 'Quick mental puzzles and logic gates.',
      icon: Icons.quiz_outlined,
      iconColor: AppColors.primaryFixedDim,
    ),
    _ChallengeOption(
      id: 'code',
      title: 'Write Code',
      badge: 'REAL EDITOR',
      badgeActive: false,
      desc: 'Debug snippets or write small functions.',
      icon: Icons.terminal,
      iconColor: AppColors.secondary,
    ),
    _ChallengeOption(
      id: 'mixed',
      title: 'Mixed',
      badge: 'RECOMMENDED',
      badgeActive: true,
      desc: 'A rotation of all challenge types.',
      icon: Icons.shuffle,
      iconColor: AppColors.tertiaryFixedDim,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: OnboardingHeader(step: 2, total: 11),
      body: OnboardingPageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How do you want to prove you're awake?",
              style: AppText.displayMobile,
            ),
            const SizedBox(height: 12),
            Opacity(
              opacity: 0.8,
              child: Text(
                'This sets how challenges work every morning.',
                style: AppText.bodyLg,
              ),
            ),
            const SizedBox(height: 40),

            ..._options.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ChallengeCard(
                  option: opt,
                  isSelected: _selected == opt.id,
                  onTap: () => setState(() => _selected = opt.id),
                ),
              ),
            ),

            const SizedBox(height: 32),
            // Info banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.onSurfaceVariant,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "You'll have 5 minutes to solve these every morning. "
                      "If you fail, the alarm volume will gradually increase to 100%.",
                      style: AppText.labelCode.copyWith(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      cta: CtaFooter(
        button: NeonCtaButton(label: 'Continue', onTap: widget.onNext),
      ),
    );
  }
}

class _ChallengeOption {
  final String id, title, badge, desc;
  final bool badgeActive;
  final IconData icon;
  final Color iconColor;
  const _ChallengeOption({
    required this.id,
    required this.title,
    required this.badge,
    required this.badgeActive,
    required this.desc,
    required this.icon,
    required this.iconColor,
  });
}

class _ChallengeCard extends StatelessWidget {
  final _ChallengeOption option;
  final bool isSelected;
  final VoidCallback onTap;
  const _ChallengeCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Pressable(
        onTap: onTap,
        scaleDown: 0.98,
        child: GlassCard(
          isActive: isSelected,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              IconBox(
                icon: option.icon,
                color: option.iconColor,
                size: 48,
                iconSize: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(option.title, style: AppText.headlineMd),
                        OptionBadge(
                            text: option.badge, active: option.badgeActive),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      option.desc,
                      style: AppText.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
