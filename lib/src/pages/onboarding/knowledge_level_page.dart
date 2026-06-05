import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/blinking_cursor.dart';
import 'package:algo_rise/src/widgets/cta_footer.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/widgets/neon_devider.dart';
import 'package:algo_rise/src/widgets/onboarding_header.dart';
import 'package:algo_rise/src/widgets/onboarding_page_body.dart';
import 'package:algo_rise/src/widgets/onboarding_scaffold.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:algo_rise/src/widgets/grid_dot_background.dart';
import 'package:flutter/material.dart';

// ─── Page 1: Knowledge Level ──────────────────────────────────────────────────
class KnowledgeLevelPage extends StatefulWidget {
  final VoidCallback? onNext;

  const KnowledgeLevelPage({super.key, this.onNext});

  @override
  State<KnowledgeLevelPage> createState() => _KnowledgeLevelPageState();
}

class _KnowledgeLevelPageState extends State<KnowledgeLevelPage>
    with SingleTickerProviderStateMixin {
  int _selected = 1; // Intermediate by default
  late AnimationController _cursor;

  static const _levels = [
    (label: 'Beginner', icon: Icons.egg_outlined),
    (label: 'Intermediate', icon: Icons.terminal),
    (label: 'Advanced', icon: Icons.code),
    (label: 'Interview Beast', icon: Icons.psychology_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _cursor = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _cursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: OnboardingHeader(
        step: 1,
        total: 7,
        hideBack: true,
        trailing: GestureDetector(
          onTap: widget.onNext,
          child: Text(
            'Skip',
            style: AppText.labelCaps.copyWith(
              color: AppColors.primaryFixedDim,
            ),
          ),
        ),
      ),
      body: _buildBody(),
      cta: CtaFooter(
        button: NeonCtaButton(
          label: 'Continue',
          onTap: widget.onNext,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        const Positioned.fill(child: GridDotBackground()),
        // Ambient top-left glow
        Positioned(
          top: -60,
          left: -60,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        OnboardingPageBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headline + cursor
              RichText(
                text: TextSpan(
                  style: AppText.headlineMd,
                  children: [
                    const TextSpan(
                      text: 'How deep does your knowledge go?',
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: BlinkingCursor(controller: _cursor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We'll calibrate your challenges.",
                style: AppText.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),

              // Level cards
              ..._levels.asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _LevelCard(
                        label: e.value.label,
                        icon: e.value.icon,
                        isSelected: _selected == e.key,
                        onTap: () => setState(() => _selected = e.key),
                      ),
                    ),
                  ),

              const NeonDivider(),
            ],
          ),
        ),
      ],
    );
  }
}

class _LevelCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _LevelCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });
  @override
  State<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<_LevelCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final sel = widget.isSelected;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Pressable(
        onTap: widget.onTap,
        scaleDown: 0.98,
        child: GlassCard(
          isActive: sel,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: 72,
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 24,
                  color: sel
                      ? AppColors.primaryFixedDim
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 16),
                Text(
                  widget.label,
                  style: AppText.bodyLg.copyWith(
                    color: sel
                        ? AppColors.primaryFixedDim
                        : AppColors.onSurface,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: sel
                      ? const Icon(
                          Icons.check_circle,
                          key: ValueKey('chk'),
                          size: 24,
                          color: AppColors.primaryFixedDim,
                        )
                      : Icon(
                          Icons.chevron_right,
                          key: const ValueKey('chev'),
                          size: 24,
                          color: _hovered
                              ? AppColors.onSurface.withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
