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

enum _TopicState { newToMe, refresher, known }

class _TopicData {
  final String name;
  _TopicState state;

  _TopicData({required this.name, required this.state});
}

class TopicSelectionPage extends StatefulWidget {
  final VoidCallback? onNext;

  const TopicSelectionPage({super.key, this.onNext});

  @override
  State<TopicSelectionPage> createState() => _TopicSelectionPageState();
}

class _TopicSelectionPageState extends State<TopicSelectionPage>
    with SingleTickerProviderStateMixin {
  bool _showNudge = true;

  final List<_TopicData> _topics = [
    _TopicData(name: 'Arrays', state: _TopicState.refresher),
    _TopicData(name: 'Strings', state: _TopicState.refresher),
    _TopicData(name: 'Linked List', state: _TopicState.newToMe),
    _TopicData(name: 'Stack/Queue', state: _TopicState.known),
    _TopicData(name: 'Trees', state: _TopicState.newToMe),
    _TopicData(name: 'Graphs', state: _TopicState.newToMe),
    _TopicData(name: 'Recursion', state: _TopicState.refresher),
    _TopicData(name: 'DP', state: _TopicState.newToMe),
    _TopicData(name: 'Sorting', state: _TopicState.known),
    _TopicData(name: 'Greedy', state: _TopicState.newToMe),
  ];

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

  void _dismissNudge() {
    setState(() {
      _showNudge = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: const OnboardingHeader(step: 5, total: 11),
      body: OnboardingPageBody(
        maxWidth: 1024,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline Section
            Text('What do you know?', style: AppText.displayMobile),
            const SizedBox(height: 8),
            Text(
              'Adjust these based on your comfort level. We\'ve pre-checked topics from your quiz.',
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 24),

            // Animated Nudge Banner
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _buildNudgeBanner(),
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: _showNudge
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),

            // Bento Grid of Topics & Plan Preview
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;

                if (maxWidth > 900) {
                  // 3 Columns Layout
                  final cardWidth = (maxWidth - 32) / 3;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      ..._topics.map(
                        (topic) => SizedBox(
                          width: cardWidth,
                          child: _TopicCard(
                            topic: topic,
                            onStateChanged: (state) {
                              setState(() {
                                topic.state = state;
                              });
                            },
                          ),
                        ),
                      ),
                      // Plan Preview Card spans 2 columns
                      SizedBox(
                        width: (cardWidth * 2) + 16,
                        child: _buildPlanPreviewCard(height: 140),
                      ),
                    ],
                  );
                } else if (maxWidth > 600) {
                  // 2 Columns Layout
                  final cardWidth = (maxWidth - 16) / 2;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      ..._topics.map(
                        (topic) => SizedBox(
                          width: cardWidth,
                          child: _TopicCard(
                            topic: topic,
                            onStateChanged: (state) {
                              setState(() {
                                topic.state = state;
                              });
                            },
                          ),
                        ),
                      ),
                      // Plan Preview Card spans full width
                      SizedBox(
                        width: maxWidth,
                        child: _buildPlanPreviewCard(height: 120),
                      ),
                    ],
                  );
                } else {
                  // 1 Column Layout (Mobile)
                  return Column(
                    children: [
                      ..._topics.map(
                        (topic) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _TopicCard(
                            topic: topic,
                            onStateChanged: (state) {
                              setState(() {
                                topic.state = state;
                              });
                            },
                          ),
                        ),
                      ),
                      _buildPlanPreviewCard(height: 120),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      cta: CtaFooter(
        button: NeonCtaButton(
          label: 'Generate My Plan',
          height: 64,
          pulseAnim: _pulseAnim,
          onTap: widget.onNext,
        ),
      ),
    );
  }

  Widget _buildNudgeBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: AppColors.secondary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your quiz score on Arrays was lower than expected — want a refresher week first?',
              style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: _dismissNudge,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: const BorderSide(color: AppColors.outlineVariant),
                  ),
                ),
                child: Text(
                  'No',
                  style: AppText.labelCaps.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _dismissNudge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  'Yes',
                  style: AppText.labelCaps.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanPreviewCard({required double height}) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'PLAN PREVIEW',
                style: AppText.labelCaps.copyWith(
                  color: AppColors.secondary,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Custom Roadmap Generation',
                style: AppText.headlineMd.copyWith(
                  color: AppColors.primary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Selecting "Need Refresher" adds targeted theory modules. "New to me" triggers full deep-dive sequences.',
                textAlign: TextAlign.center,
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

// ─── Topic Card Component ──────────────────────────────────────────────────────
class _TopicCard extends StatefulWidget {
  final _TopicData topic;
  final ValueChanged<_TopicState> onStateChanged;

  const _TopicCard({required this.topic, required this.onStateChanged});

  @override
  State<_TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<_TopicCard> {
  bool _hovered = false;

  Color _getIndicatorColor(_TopicState state) {
    switch (state) {
      case _TopicState.known:
        return AppColors.secondary;
      case _TopicState.refresher:
        return AppColors.tertiaryFixedDim; // Green in app theme
      case _TopicState.newToMe:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topic = widget.topic;
    final state = topic.state;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GlassCard(
        isActive: _hovered,
        activeColor: AppColors.secondary.withOpacity(0.4),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Topic Name + State Dot Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  topic.name,
                  style: AppText.headlineMd.copyWith(
                    fontFamily: 'Outfit',
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getIndicatorColor(state),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Selection Segment Row (New, Refresh, Know)
            Row(
              children: [
                Expanded(
                  child: _buildSegmentButton(
                    label: 'New',
                    icon: Icons.radio_button_unchecked,
                    isSelected: state == _TopicState.newToMe,
                    activeColor: AppColors.primaryFixedDim,
                    onTap: () => widget.onStateChanged(_TopicState.newToMe),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildSegmentButton(
                    label: 'Refresh',
                    icon: Icons.contrast,
                    isSelected: state == _TopicState.refresher,
                    activeColor: AppColors.tertiaryFixedDim,
                    onTap: () => widget.onStateChanged(_TopicState.refresher),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildSegmentButton(
                    label: 'Know',
                    icon: Icons.check_circle_outline,
                    isSelected: state == _TopicState.known,
                    activeColor: AppColors.secondary,
                    onTap: () => widget.onStateChanged(_TopicState.known),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return Pressable(
      onTap: onTap,
      scaleDown: 0.95,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? activeColor : AppColors.outlineVariant,
            width: 1,
          ),
        ),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? activeColor : AppColors.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: AppText.labelCaps.copyWith(
                  fontSize: 9,
                  letterSpacing: 0.5,
                  color: isSelected ? activeColor : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
