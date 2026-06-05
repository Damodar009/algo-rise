import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/cta_footer.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/widgets/onboarding_header.dart';
import 'package:algo_rise/src/widgets/onboarding_page_body.dart';
import 'package:algo_rise/src/widgets/onboarding_scaffold.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:algo_rise/src/widgets/radio_circle.dart';
import 'package:flutter/material.dart';

// ─── Page 5: Wake Intensity ───────────────────────────────────────────────────
enum _Difficulty { easy, balanced, hardcore, impossible }

class WakeIntensityPage extends StatefulWidget {
  final VoidCallback? onNext;

  const WakeIntensityPage({super.key, this.onNext});

  @override
  State<WakeIntensityPage> createState() => _WakeIntensityPageState();
}

class _WakeIntensityPageState extends State<WakeIntensityPage>
    with SingleTickerProviderStateMixin {
  _Difficulty _selected = _Difficulty.balanced;
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

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

  static const _options = [
    _DiffOption(
      _Difficulty.easy,
      'Easy Wake',
      Icons.filter_drama_outlined,
      AppColors.tertiaryFixedDim,
      AppColors.surfaceContainerHigh,
      'Gentle vibrations, melodic chimes. Pure serenity.',
    ),
    _DiffOption(
      _Difficulty.balanced,
      'Balanced',
      Icons.bolt,
      AppColors.primaryFixedDim,
      Color(0xFF003739),
      'Standard grind. Rising with purpose.',
      recommended: true,
    ),
    _DiffOption(
      _Difficulty.hardcore,
      'Hardcore',
      Icons.alarm_off,
      AppColors.secondary,
      AppColors.surfaceContainerHigh,
      "No snooze allowed. The alarm won't stop until you move.",
    ),
    _DiffOption(
      _Difficulty.impossible,
      'Impossible',
      Icons.terminal,
      AppColors.error,
      Color(0xFF2D0003),
      'Hard code, no mercy. Resolve logic to earn silence.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: OnboardingHeader(step: 5, total: 7),
      body: OnboardingPageBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline with "brutal" in cyan
            RichText(
              text: TextSpan(
                style: AppText.displayMobile,
                children: const [
                  TextSpan(text: 'How '),
                  TextSpan(
                    text: 'brutal',
                    style: TextStyle(color: AppColors.primaryFixedDim),
                  ),
                  TextSpan(text: ' should your\nmornings be?'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a wake-up intensity that matches your discipline.',
              style: AppText.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            ..._options.map(
              (opt) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _DiffCard(
                  option: opt,
                  isSelected: _selected == opt.id,
                  onTap: () => setState(() => _selected = opt.id),
                ),
              ),
            ),
            const SizedBox(height: 8),

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
                          '// WAKE_INTENSITY_PROTOCOL',
                          style: AppText.labelCode.copyWith(
                            color: AppColors.primaryFixedDim,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'if (user.state == "groggy") { intensity++; }',
                          textAlign: TextAlign.center,
                          style: AppText.labelCode.copyWith(
                            fontSize: 10,
                            color: AppColors.onSurfaceVariant
                                .withValues(alpha: 0.4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'while (alarm.active) { user.engagement = true; }',
                          textAlign: TextAlign.center,
                          style: AppText.labelCode.copyWith(
                            fontSize: 10,
                            color: AppColors.onSurfaceVariant
                                .withValues(alpha: 0.4),
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
        subLabel: 'ALGORISE NEURAL SYNC V2.4',
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

// ── Difficulty Option Data ─────────────────────────────────────────────────────
class _DiffOption {
  final _Difficulty id;
  final String title, subtitle;
  final IconData icon;
  final Color iconColor, iconBg;
  final bool recommended;
  const _DiffOption(
    this.id,
    this.title,
    this.icon,
    this.iconColor,
    this.iconBg,
    this.subtitle, {
    this.recommended = false,
  });
}

// ── Difficulty Card ────────────────────────────────────────────────────────────
class _DiffCard extends StatefulWidget {
  final _DiffOption option;
  final bool isSelected;
  final VoidCallback onTap;
  const _DiffCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });
  @override
  State<_DiffCard> createState() => _DiffCardState();
}

class _DiffCardState extends State<_DiffCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final sel = widget.isSelected;
    final opt = widget.option;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Pressable(
        onTap: widget.onTap,
        scaleDown: 0.98,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 88,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: sel
                ? AppColors.primaryFixedDim.withValues(alpha: 0.05)
                : _hovered
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: sel
                  ? AppColors.primaryFixedDim
                  : opt.id == _Difficulty.impossible
                      ? AppColors.error.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.08),
            ),
            boxShadow: sel
                ? [
                    BoxShadow(
                      color: AppColors.primaryFixedDim.withValues(alpha: 0.15),
                      blurRadius: 20,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: opt.iconBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: AnimatedScale(
                        scale: _hovered ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(opt.icon, size: 24, color: opt.iconColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opt.title,
                          style: AppText.bodyLg.copyWith(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600,
                            color: sel
                                ? AppColors.primary
                                : AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          opt.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.bodyMd.copyWith(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  RadioCircle(selected: sel),
                ],
              ),
              // RECOMMENDED badge
              if (opt.recommended)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryFixedDim,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'RECOMMENDED',
                      style: AppText.labelCaps.copyWith(
                        fontSize: 9,
                        color: AppColors.onPrimaryFixed,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
