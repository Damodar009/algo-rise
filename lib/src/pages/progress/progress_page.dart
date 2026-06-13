import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/grid_dot_background.dart';
import 'package:algo_rise/src/widgets/activity_heatmap.dart';
import 'package:algo_rise/src/widgets/xp_progression_chart.dart';
import 'package:algo_rise/src/widgets/verdict_distribution.dart';
import 'package:algo_rise/src/widgets/progress_stat_card.dart';
import 'package:algo_rise/src/widgets/milestones_scroll.dart';
import 'package:algo_rise/src/services/preferences_service.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  // Filter state: 0 = Week, 1 = Month, 2 = All Time
  int _activeFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService.instance;
    final xp = prefs.totalXp;
    final xpText = xp >= 1000 ? '${(xp / 1000).toStringAsFixed(1)}k' : '$xp';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background dots grid
          const Positioned.fill(child: GridDotBackground()),

          // Ambient glow (Top left cyan)
          _buildAmbientGlow(
            top: -100,
            left: -80,
            color: AppColors.primaryFixedDim,
            size: 320,
            opacity: 0.07,
          ),

          // Ambient glow (Bottom right purple)
          _buildAmbientGlow(
            bottom: -120,
            right: -80,
            color: AppColors.secondary,
            size: 280,
            opacity: 0.05,
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                _buildTopAppBar(),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page title and Filter
                        _buildHeaderAndFilter(),
                        const SizedBox(height: 20),

                        // Activity Heatmap
                        const ActivityHeatmap(),
                        const SizedBox(height: 20),

                        // XP Chart & Verdict Distribution (Responsive Layout)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 600) {
                              return const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: XpProgressionChart()),
                                  SizedBox(width: 16),
                                  Expanded(child: VerdictDistribution()),
                                ],
                              );
                            } else {
                              return const Column(
                                children: [
                                  XpProgressionChart(),
                                  SizedBox(height: 20),
                                  VerdictDistribution(),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),

                        // Stats Grid 2x3
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.4,
                          children: [
                            ProgressStatCard(
                              icon: Icons.bedtime,
                              iconColor: AppColors.primaryFixedDim,
                              label: 'Total Wake-ups',
                              value: '${prefs.wakeups}',
                            ),
                            ProgressStatCard(
                              icon: Icons.timer,
                              iconColor: AppColors.tertiaryFixedDim,
                              label: 'Avg Solve Time',
                              value: prefs.avgTime,
                              unit: 'min',
                            ),
                            const ProgressStatCard(
                              icon: Icons.military_tech,
                              iconColor: AppColors.secondary,
                              label: 'Current Rank',
                              value: 'Elite',
                            ),
                            const ProgressStatCard(
                              icon: Icons.snooze,
                              iconColor: AppColors.error,
                              label: 'Snooze Count',
                              value: '3',
                            ),
                            const ProgressStatCard(
                              icon: Icons.history_edu,
                              iconColor: AppColors.primaryFixedDim,
                              label: 'Hard Problems',
                              value: '12',
                            ),
                            ProgressStatCard(
                              icon: Icons.emoji_events,
                              iconColor: AppColors.tertiaryFixedDim,
                              label: 'XP Earned',
                              value: xpText,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Milestones scroll
                        const MilestonesScroll(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Glass Top App Bar
  Widget _buildTopAppBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.8),
            border: const Border(
              bottom: BorderSide(
                color: Colors.white10,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // User avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHighest,
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDlZ5HaTkUk6QHSmp-1ySPxIUDYevxFUBRFDEhP8-KCaTDSYqNsXIvIDcAnmhnW5_lCZnRuTc4Trqu34LrE_pCwXjO67dvLTC_tfLYQpQfjPawMJvGCCW9qWlTkCCpZVS01A4NcvHxCTTCkErIXkXJNaqrC-BkuQheK0Dhatf3kaSwhNUKuGnIFN4oGF5wAkwbjDvGk7V70g6jIrMZefFnBgxZG4l5CtPp_AXF-6nz61CfVqFZOq2hmuxgpJpzRfZM0MsOCBajxunQs',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      color: AppColors.onSurfaceVariant,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // App Title
              Text(
                'AlgoRise',
                style: AppText.headlineMd.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              // Streak Bolt
              Row(
                children: [
                  const Icon(
                    Icons.bolt,
                    color: AppColors.primaryFixedDim,
                    size: 20,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${PreferencesService.instance.streak}',
                    style: AppText.labelCaps.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryFixedDim,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Notification Icon Button
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.notifications,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header & Filter Row
  Widget _buildHeaderAndFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: AppText.headlineMd.copyWith(
            fontSize: 28,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterButton('Week', 0),
              _buildFilterButton('Month', 1),
              _buildFilterButton('All Time', 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String text, int index) {
    final isActive = _activeFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilterIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryFixed : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: AppText.labelCaps.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isActive ? AppColors.onPrimaryFixed : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // Helper to build ambient glow blobs
  Widget _buildAmbientGlow({
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
