import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/code_atmosphere_card.dart';
import 'package:algo_rise/src/widgets/cta_footer.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/widgets/onboarding_header.dart';
import 'package:algo_rise/src/widgets/onboarding_page_body.dart';
import 'package:algo_rise/src/widgets/onboarding_scaffold.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:flutter/material.dart';

// ─── Page 6: Why Are You Here ─────────────────────────────────────────────────
class WhyAreYouHerePage extends StatefulWidget {
  final VoidCallback? onNext;

  const WhyAreYouHerePage({super.key, this.onNext});

  @override
  State<WhyAreYouHerePage> createState() => _WhyAreYouHerePageState();
}

class _WhyAreYouHerePageState extends State<WhyAreYouHerePage>
    with SingleTickerProviderStateMixin {
  final Set<String> _selected = {};
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

  static const _options = [
    'Crack interviews',
    'Improve problem solving',
    'Build discipline',
    'Stop oversleeping',
    'Stay consistent',
    'Competitive programming',
  ];

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
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
      header: OnboardingHeader(step: 6, total: 7),
      body: OnboardingPageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Why are you here?', style: AppText.displayMobile),
            const SizedBox(height: 8),
            Text("We'll remind you on hard mornings.", style: AppText.bodyLg),
            const SizedBox(height: 32),

            // Code atmosphere visual (reuses shared widget)
            const CodeAtmosphereCard(),
            const SizedBox(height: 32),

            // Selection list
            ..._options.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MotivationCard(
                  label: opt,
                  isSelected: _selected.contains(opt),
                  onTap: () => setState(
                    () => _selected.contains(opt)
                        ? _selected.remove(opt)
                        : _selected.add(opt),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      cta: CtaFooter(
        button: NeonCtaButton(
          label: 'Continue',
          height: 64,
          pulseAnim: _pulseAnim,
          onTap: widget.onNext,
        ),
      ),
    );
  }
}

// ── Motivation Card ────────────────────────────────────────────────────────────
class _MotivationCard extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _MotivationCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  @override
  State<_MotivationCard> createState() => _MotivationCardState();
}

class _MotivationCardState extends State<_MotivationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final sel = widget.isSelected;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Pressable(
        onTap: widget.onTap,
        scaleDown: 0.95,
        child: GlassCard(
          isActive: sel,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: AppText.bodyMd.copyWith(
                  color: sel || _hovered
                      ? AppColors.primaryFixedDim
                      : AppColors.onSurface,
                ),
              ),
              AnimatedOpacity(
                opacity: sel ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.check_circle,
                  size: 24,
                  color: AppColors.primaryFixedDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
