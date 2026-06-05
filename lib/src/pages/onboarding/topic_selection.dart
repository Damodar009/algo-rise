import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/cta_footer.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/widgets/onboarding_header.dart';
import 'package:algo_rise/src/widgets/onboarding_page_body.dart';
import 'package:algo_rise/src/widgets/onboarding_scaffold.dart';
import 'package:algo_rise/src/widgets/topic_chip.dart';
import 'package:flutter/material.dart';

// ─── Page 4: Topic Selection ──────────────────────────────────────────────────
class TopicSelectionPage extends StatefulWidget {
  final VoidCallback? onNext;

  const TopicSelectionPage({super.key, this.onNext});

  @override
  State<TopicSelectionPage> createState() => _TopicSelectionPageState();
}

class _TopicSelectionPageState extends State<TopicSelectionPage> {
  final Set<String> _selected = {};

  static const _topics = [
    'Arrays',
    'Strings',
    'Linked Lists',
    'Stacks & Queues',
    'Trees',
    'Graphs',
    'DP',
    'Recursion',
    'Sorting',
    'Binary Search',
    'Heaps',
    'Tries',
    'Bit Manipulation',
    'Two Pointers',
    'Sliding Window',
    'System Design',
  ];

  bool get _canContinue => _selected.length >= 3;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: OnboardingHeader(
        step: 4,
        total: 7,
        trailing: Text(
          'DATA STRUCTURES & ALGORITHMS',
          style: AppText.labelCaps.copyWith(color: AppColors.primaryFixedDim),
        ),
      ),
      body: OnboardingPageBody(
        maxWidth: 672,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What should we throw at you?',
              style: AppText.headlineMd,
            ),
            const SizedBox(height: 8),
            Text(
              "Pick at least 3. We'll rotate daily.",
              style: AppText.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Chip grid
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _topics
                  .map(
                    (t) => TopicChip(
                      label: t,
                      isSelected: _selected.contains(t),
                      onTap: () => setState(
                        () => _selected.contains(t)
                            ? _selected.remove(t)
                            : _selected.add(t),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 32),

            // Code aesthetic card
            GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryFixedDim.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "\$ select * from foundations where mastery >= 'expert';",
                          textAlign: TextAlign.center,
                          style: AppText.labelCode.copyWith(
                            color: AppColors.primaryFixedDim,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '// Selected topics populate your morning algorithm feed.',
                          textAlign: TextAlign.center,
                          style: AppText.labelCode.copyWith(
                            fontSize: 11,
                            color: AppColors.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      cta: CtaFooter(
        button: NeonCtaButton(
          label: 'Continue',
          enabled: _canContinue,
          onTap: _canContinue ? widget.onNext : null,
        ),
      ),
    );
  }
}
