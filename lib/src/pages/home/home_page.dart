import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/bottom_nav.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/grid_dot_background.dart';
import 'package:flutter/material.dart';

// ─── Home Page ────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  final bool isNested;
  const HomePage({super.key, this.isNested = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _navIndex = 0;
  late AnimationController _glowPulse;

  @override
  void initState() {
    super.initState();
    _glowPulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyContent = Stack(
      children: [
        // Subtle grid background
        const Positioned.fill(child: GridDotBackground()),

        // Ambient glows
        _ambientGlow(
          top: -80,
          left: -60,
          color: AppColors.primaryFixedDim,
          size: 300,
          opacity: 0.06,
        ),
        _ambientGlow(
          bottom: -100,
          right: -60,
          color: AppColors.secondary,
          size: 260,
          opacity: 0.04,
        ),

        // Main content
        SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStreakBanner(),
                      const SizedBox(height: 24),
                      _buildTodayChallenge(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('QUICK ACTIONS'),
                      const SizedBox(height: 12),
                      _buildQuickActions(),
                      const SizedBox(height: 24),
                      _buildSectionLabel('RECENT ACTIVITY'),
                      const SizedBox(height: 12),
                      _buildActivityFeed(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (widget.isNested) {
      return bodyContent;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: bodyContent,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          // App wordmark
          RichText(
            text: TextSpan(
              style: AppText.headlineMd.copyWith(fontSize: 20),
              children: const [
                TextSpan(text: 'Algo'),
                TextSpan(
                  text: 'Rise',
                  style: TextStyle(color: AppColors.primaryFixedDim),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Notification bell
          _IconBtn(Icons.notifications_none_outlined, onTap: () {}),
          const SizedBox(width: 8),
          // Avatar circle
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceContainerHigh,
                border: Border.all(
                  color: AppColors.primaryFixedDim.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.onSurfaceVariant,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Streak Banner ────────────────────────────────────────────────────────────
  Widget _buildStreakBanner() {
    return AnimatedBuilder(
      animation: _glowPulse,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryFixedDim.withValues(alpha: 0.12),
              AppColors.primary.withValues(alpha: 0.04),
            ],
          ),
          border: Border.all(
            color: AppColors.primaryFixedDim.withValues(
              alpha: 0.15 + _glowPulse.value * 0.1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryFixedDim.withValues(
                alpha: 0.05 + _glowPulse.value * 0.06,
              ),
              blurRadius: 24,
            ),
          ],
        ),
        child: Row(
          children: [
            // Flame icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.tertiaryFixed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_fire_department,
                color: AppColors.tertiaryFixed,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '0 Day Streak',
                    style: AppText.headlineMd.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Set your alarm to start your streak today.',
                    style: AppText.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 13,
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

  // ── Today's Challenge Card ───────────────────────────────────────────────────
  Widget _buildTodayChallenge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel("TODAY'S CHALLENGE"),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(0),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Code preview header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Traffic lights
                    for (final c in [
                      const Color(0xFFFF5F56),
                      const Color(0xFFFFBD2E),
                      const Color(0xFF27C93F),
                    ]) ...[
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: c.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFixedDim.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.primaryFixedDim.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                      child: Text(
                        'MEDIUM',
                        style: AppText.labelCaps.copyWith(
                          fontSize: 9,
                          color: AppColors.primaryFixedDim,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Code body
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Two Sum',
                      style: AppText.headlineMd.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Given an array of integers nums and an integer target, '
                      'return indices of the two numbers such that they add up to target.',
                      style: AppText.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Code snippet
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _codeSnippetLine(
                            'def two_sum(nums, target):',
                            AppColors.primaryFixedDim,
                          ),
                          _codeSnippetLine(
                            '    seen = {}',
                            AppColors.onSurfaceVariant,
                          ),
                          _codeSnippetLine(
                            '    for i, n in enumerate(nums):',
                            AppColors.secondary.withValues(alpha: 0.8),
                          ),
                          _codeSnippetLine(
                            '        if target - n in seen: ...',
                            AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tags
                    Wrap(
                      spacing: 8,
                      children: ['Array', 'Hash Map', 'O(n)'].map((t) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            t,
                            style: AppText.labelCode.copyWith(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Solve button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Material(
                        color: AppColors.primaryFixedDim,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {},
                          child: Center(
                            child: Text(
                              'Solve Challenge →',
                              style: AppText.bodyMd.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onPrimaryFixed,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _codeSnippetLine(String text, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: AppText.labelCode.copyWith(fontSize: 12, color: color),
    ),
  );

  // ── Quick Actions ────────────────────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      (Icons.alarm, 'Set Alarm', AppColors.primaryFixedDim),
      (Icons.code, 'Practice', AppColors.secondary),
      (Icons.leaderboard, 'Rankings', AppColors.tertiaryFixed),
      (Icons.bar_chart, 'Stats', AppColors.primaryFixed),
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      children: actions.map((a) {
        return GestureDetector(
          onTap: () {},
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(a.$1, color: a.$3, size: 28),
                const SizedBox(height: 8),
                Text(
                  a.$2,
                  style: AppText.labelCaps.copyWith(
                    fontSize: 9,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Activity Feed ────────────────────────────────────────────────────────────
  Widget _buildActivityFeed() {
    final items = [
      (
        'Completed onboarding',
        'Just now',
        Icons.check_circle_outline,
        AppColors.tertiaryFixedDim,
      ),
      (
        'Alarm set for 6:00 AM',
        'Pending',
        Icons.alarm,
        AppColors.primaryFixedDim,
      ),
      (
        'First challenge unlocked',
        'Today',
        Icons.lock_open,
        AppColors.secondary,
      ),
    ];
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.$4.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.$3, color: item.$4, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: AppText.bodyMd.copyWith(fontSize: 14),
                      ),
                      Text(
                        item.$2,
                        style: AppText.labelCaps.copyWith(
                          fontSize: 10,
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
      }).toList(),
    );
  }

  // ── Bottom Navigation Bar ────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return BottomNav(
      currentIndex: _navIndex,
      onTap: (int i) {
        setState(() => _navIndex = i);
      },
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) => Text(
    label,
    style: AppText.labelCaps.copyWith(color: AppColors.primaryFixedDim),
  );

  Positioned _ambientGlow({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required Color color,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: opacity),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small icon button ─────────────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn(this.icon, {required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Icon(icon, color: AppColors.onSurfaceVariant, size: 22),
    ),
  );
}
