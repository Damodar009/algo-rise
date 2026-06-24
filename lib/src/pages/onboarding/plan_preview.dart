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

enum _Pace { fewer, normal, more }

class _WeekData {
  final int number;
  final String title;
  final List<String> badges;
  final String description;
  final int baseProblemsCount;
  final String difficulty;
  final String difficultyType; // 'sage', 'amber', 'terracotta'
  final bool hasReview;

  _WeekData({
    required this.number,
    required this.title,
    required this.badges,
    required this.description,
    required this.baseProblemsCount,
    required this.difficulty,
    required this.difficultyType,
    this.hasReview = false,
  });
}

class PlanPreviewPage extends StatefulWidget {
  final VoidCallback? onNext;

  const PlanPreviewPage({super.key, this.onNext});

  @override
  State<PlanPreviewPage> createState() => _PlanPreviewPageState();
}

class _PlanPreviewPageState extends State<PlanPreviewPage>
    with SingleTickerProviderStateMixin {
  _Pace _selectedPace = _Pace.normal;

  final List<_WeekData> _defaultWeeks = [
    _WeekData(
      number: 1,
      title: 'Week 1: Arrays',
      badges: ['Core', 'Frequent Interview Topic'],
      description: 'Fundamental building block for most DSA problems. Master iteration and in-place modification.',
      baseProblemsCount: 12,
      difficulty: 'Easy → Medium',
      difficultyType: 'sage',
    ),
    _WeekData(
      number: 2,
      title: 'Week 2: Strings',
      badges: ['Core'],
      description: 'Focus on manipulation, two-pointer patterns, and sliding window efficiency.',
      baseProblemsCount: 10,
      difficulty: 'Easy → Medium',
      difficultyType: 'sage',
      hasReview: true,
    ),
    _WeekData(
      number: 3,
      title: 'Week 3: Linked Lists',
      badges: ['Core'],
      description: 'Understanding pointers, memory layout, and common pitfalls like cycle detection.',
      baseProblemsCount: 8,
      difficulty: 'Medium',
      difficultyType: 'amber',
    ),
  ];

  final List<String> _customModules = [];
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

  int _getProblemsCount(int baseCount) {
    switch (_selectedPace) {
      case _Pace.fewer:
        return (baseCount * 0.7).round();
      case _Pace.normal:
        return baseCount;
      case _Pace.more:
        return (baseCount * 1.5).round();
    }
  }

  int get _estimatedTotalWeeks {
    final count = _defaultWeeks.length + _customModules.length;
    switch (_selectedPace) {
      case _Pace.fewer:
        return count + 1; // takes slightly longer to complete
      case _Pace.normal:
        return count * 4; // base reference
      case _Pace.more:
        return count * 3; // faster speed
    }
  }

  void _addCustomModule() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Add Custom Module',
          style: AppText.headlineMd.copyWith(color: AppColors.primary),
        ),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: AppText.bodyMd.copyWith(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: 'e.g. Binary Search, Heaps',
            hintStyle: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant.withOpacity(0.5)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryFixedDim),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                setState(() {
                  _customModules.add(textController.text.trim());
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryFixedDim,
              foregroundColor: AppColors.onPrimaryFixed,
            ),
            child: Text('Add', style: AppText.labelCaps),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: const OnboardingHeader(step: 9, total: 11),
      body: OnboardingPageBody(
        maxWidth: 1024,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Description
            Text('Your Custom Roadmap', style: AppText.displayMobile),
            const SizedBox(height: 8),
            Text(
              'We\'ve structured your learning path based on interview frequency and foundational dependencies. Reorder weeks if you have specific priorities.',
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 32),

            // Scrollable List of Weeks
            ..._defaultWeeks.map((week) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildWeekCard(week),
            )),

            // Custom added modules
            ..._customModules.asMap().entries.map((entry) {
              final index = entry.key;
              final name = entry.value;
              final weekNum = _defaultWeeks.length + index + 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCustomWeekCard(weekNum, name),
              );
            }),

            // Add Custom Module Placeholder Card
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Pressable(
                onTap: _addCustomModule,
                scaleDown: 0.98,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.outlineVariant,
                      width: 1.5,
                      style: BorderStyle.solid, // solid but dashed effect simulated
                    ),
                    color: Colors.white.withOpacity(0.01),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'ADD CUSTOM MODULE',
                        style: AppText.labelCaps.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Adjust Pace Section
            _buildAdjustPaceCard(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      cta: CtaFooter(
        subLabel: 'Estimated completion: $_estimatedTotalWeeks weeks',
        button: NeonCtaButton(
          label: 'Confirm Plan',
          height: 64,
          pulseAnim: _pulseAnim,
          onTap: widget.onNext,
        ),
      ),
    );
  }

  Widget _buildWeekCard(_WeekData week) {
    return _buildWeekCardLayout(
      weekNum: week.number,
      title: week.title,
      description: week.description,
      problemsCount: _getProblemsCount(week.baseProblemsCount),
      difficulty: week.difficulty,
      difficultyType: week.difficultyType,
      badges: week.badges,
      hasReview: week.hasReview,
    );
  }

  Widget _buildCustomWeekCard(int weekNum, String title) {
    return _buildWeekCardLayout(
      weekNum: weekNum,
      title: 'Week $weekNum: $title',
      description: 'Custom learning target. Solve personalized algorithmic problems on $title.',
      problemsCount: _getProblemsCount(8),
      difficulty: 'Medium',
      difficultyType: 'amber',
      badges: ['Custom'],
      hasReview: false,
    );
  }

  Widget _buildWeekCardLayout({
    required int weekNum,
    required String title,
    required String description,
    required int problemsCount,
    required String difficulty,
    required String difficultyType,
    required List<String> badges,
    required bool hasReview,
  }) {
    Color badgeBg;
    Color badgeText;

    if (difficultyType == 'sage') {
      badgeBg = const Color(0xFFF0FDF4).withOpacity(0.1);
      badgeText = const Color(0xFF22C55E);
    } else if (difficultyType == 'amber') {
      badgeBg = const Color(0xFFFFFBEB).withOpacity(0.1);
      badgeText = const Color(0xFFF59E0B);
    } else {
      badgeBg = const Color(0xFFFEF2F2).withOpacity(0.1);
      badgeText = const Color(0xFFEF4444);
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag indicator and step number
          Column(
            children: [
              const Icon(
                Icons.drag_indicator,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$weekNum',
                  style: AppText.labelCode.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Main Card Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and badges row
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppText.headlineMd.copyWith(
                        fontFamily: 'Outfit',
                        fontSize: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    ...badges.map((b) {
                      final isTerracotta = b == 'Frequent Interview Topic';
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isTerracotta
                              ? const Color(0xFFFEF2F2).withOpacity(0.1)
                              : AppColors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                          border: isTerracotta
                              ? const Border(left: BorderSide(color: Color(0xFFEF4444), width: 2))
                              : null,
                        ),
                        child: Text(
                          b.toUpperCase(),
                          style: AppText.labelCaps.copyWith(
                            fontSize: 9,
                            color: isTerracotta ? const Color(0xFFEF4444) : AppColors.onSurfaceVariant,
                          ),
                        ),
                      );
                    }),
                    if (hasReview)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '+ LIGHT REVIEW: ARRAYS',
                          style: AppText.labelCaps.copyWith(
                            fontSize: 9,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  description,
                  style: AppText.bodyMd.copyWith(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 16),

                // Card Footer (Problems count + difficulty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.format_list_numbered,
                          color: AppColors.onSurfaceVariant,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$problemsCount problems',
                          style: AppText.labelCode.copyWith(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            difficulty.toUpperCase(),
                            style: AppText.labelCaps.copyWith(
                              fontSize: 9,
                              color: badgeText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'View Problems',
                        style: AppText.labelCaps.copyWith(
                          color: AppColors.secondary,
                          fontSize: 11,
                        ),
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

  Widget _buildAdjustPaceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
            ),
            child: const Icon(
              Icons.speed,
              color: AppColors.secondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adjust Pace',
                  style: AppText.headlineMd.copyWith(fontSize: 18, color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  'Current: 4 hours / week. Adjust density per module.',
                  style: AppText.bodyMd.copyWith(fontSize: 12, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Pace Selector Segment Toggle
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPaceButton('Fewer Problems', _Pace.fewer),
                _buildPaceNormalLabel(),
                _buildPaceButton('More Problems', _Pace.more),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaceButton(String label, _Pace pace) {
    final isSelected = _selectedPace == pace;
    return Pressable(
      onTap: () {
        setState(() {
          _selectedPace = pace;
        });
      },
      scaleDown: 0.95,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppText.labelCaps.copyWith(
            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPaceNormalLabel() {
    final isSelected = _selectedPace == _Pace.normal;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPace = _Pace.normal;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        child: Text(
          'NORMAL',
          style: AppText.labelCaps.copyWith(
            color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant.withOpacity(0.5),
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
