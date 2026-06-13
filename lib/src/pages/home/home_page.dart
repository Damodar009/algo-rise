import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/daily_challenge_card.dart';
import 'package:algo_rise/src/widgets/grid_dot_background.dart';
import 'package:algo_rise/src/widgets/next_alarm_hero_card.dart';
import 'package:algo_rise/src/widgets/quick_actions_row.dart';
import 'package:algo_rise/src/widgets/rank_progress_card.dart';
import 'package:algo_rise/src/widgets/stat_grid_card.dart';
import 'package:go_router/go_router.dart';
import 'package:algo_rise/src/services/preferences_service.dart';

// ─── Home Page ────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  final bool isNested;
  const HomePage({super.key, this.isNested = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService.instance;
    final xp = prefs.totalXp;
    final xpText = xp >= 1000 ? '${(xp / 1000).toStringAsFixed(1)}k' : '$xp';

    final bodyContent = Stack(
      children: [
        // Subtle grid background
        const Positioned.fill(child: GridDotBackground()),

        // Top-left ambient glow (cyan)
        _ambientGlow(
          top: -100,
          left: -80,
          color: AppColors.primaryFixedDim,
          size: 320,
          opacity: 0.07,
        ),

        // Bottom-right ambient glow (purple)
        _ambientGlow(
          bottom: -120,
          right: -80,
          color: AppColors.secondary,
          size: 280,
          opacity: 0.05,
        ),

        // Scrollable content
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Fixed glass top app bar
              _buildTopAppBar(),
              // Scrollable body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Hero: Next Alarm ──────────────────────────────────
                      const NextAlarmHeroCard(
                        time: '06:30',
                        period: 'AM',
                        firesIn: '8h 22m',
                        tags: ['Balanced', 'Code', 'Python', 'Arrays'],
                      ),
                      const SizedBox(height: 20),

                      // ── Stats Grid ────────────────────────────────────────
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.6,
                        children: [
                          StatGridCard(
                            icon: Icons.local_fire_department,
                            iconColor: AppColors.tertiaryFixedDim,
                            label: 'STREAK',
                            value: '${prefs.streak} days',
                          ),
                          StatGridCard(
                            icon: Icons.grade,
                            iconColor: AppColors.secondary,
                            label: 'TOTAL XP',
                            value: xpText,
                          ),
                          StatGridCard(
                            icon: Icons.check_circle,
                            iconColor: AppColors.primaryFixedDim,
                            label: 'SOLVED',
                            value: '${prefs.solvedCount}',
                          ),
                          StatGridCard(
                            icon: Icons.calendar_today,
                            iconColor: AppColors.tertiaryFixed,
                            label: 'RATE',
                            value: '82%',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Quick Actions ─────────────────────────────────────
                      _sectionLabel('QUICK ACTIONS'),
                      const SizedBox(height: 12),
                      const QuickActionsRow(),
                      const SizedBox(height: 20),

                      // ── Rank Progress ─────────────────────────────────────
                      const RankProgressCard(
                        rankName: 'Script Kiddy',
                        nextRank: 'Code Warrior',
                        xpToNext: 260,
                        progress: 0.74,
                      ),
                      const SizedBox(height: 20),

                      // ── Daily Challenge ───────────────────────────────────
                      DailyChallengeCard(
                        title: 'Invert Binary Tree',
                        difficulty: 'Medium',
                        language: 'Python',
                        bonusXp: 15,
                        onSolve: () => GoRouter.of(context).push('/challenge'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (widget.isNested) return bodyContent;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: bodyContent,
    );
  }

  // ── Top App Bar ────────────────────────────────────────────────────────────
  Widget _buildTopAppBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHigh,
                  border: Border.all(
                    color: AppColors.primaryFixedDim.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.onSurfaceVariant,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              // Greeting
              RichText(
                text: TextSpan(
                  style: AppText.headlineMd.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryFixedDim,
                    letterSpacing: -0.3,
                  ),
                  children: const [
                    TextSpan(text: 'gm, '),
                    TextSpan(text: '@dev_user 👾'),
                  ],
                ),
              ),
              const Spacer(),
              // Streak pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryFixedDim.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.tertiaryFixedDim.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: AppColors.tertiaryFixed,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${PreferencesService.instance.streak}',
                      style: AppText.labelCode.copyWith(
                        fontSize: 13,
                        color: AppColors.tertiaryFixed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _sectionLabel(String label) => Text(
    label,
    style: AppText.labelCaps.copyWith(
      fontSize: 10,
      color: AppColors.onSurfaceVariant,
      letterSpacing: 1.0,
    ),
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
