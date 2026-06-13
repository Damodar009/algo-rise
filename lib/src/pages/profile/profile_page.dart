import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/grid_dot_background.dart';
import 'package:algo_rise/src/widgets/profile_hero.dart';
import 'package:algo_rise/src/widgets/profile_stats_bento.dart';
import 'package:algo_rise/src/widgets/language_proficiency.dart';
import 'package:algo_rise/src/widgets/achievements_grid.dart';
import 'package:algo_rise/src/widgets/preferences_list.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background dots grid
          const Positioned.fill(child: GridDotBackground()),

          // Ambient top-center glow (cyberpunk cyan)
          _buildAmbientGlow(
            top: -150,
            left: MediaQuery.of(context).size.width / 2 - 200,
            color: AppColors.primaryFixedDim,
            size: 400,
            opacity: 0.06,
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top App Bar
                _buildTopAppBar(),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                    child: Column(
                      children: [
                        // Profile Hero
                        const ProfileHero(),
                        const SizedBox(height: 24),

                        // Stats Bento Grid
                        const ProfileStatsBento(),
                        const SizedBox(height: 24),

                        // Language Proficiency
                        const LanguageProficiency(),
                        const SizedBox(height: 24),

                        // Achievements Grid
                        const AchievementsGrid(),
                        const SizedBox(height: 24),

                        // Preferences/Settings Menu
                        const PreferencesList(),
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

  // Top Glass App Bar
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
              // User avatar image
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA-ALhl6GLnp3Zcs9I5Dt6nWI3kj-jmLCWYVNUaHAOEFuncpkZ_WTZ9YMIZB1L61xiFZjW9W7AdHGusrfKfvI1jY_ox0oVQm3RMq9jJcr1mWH4zRolJuUH9y_N6esgvbymtIm3SqvDQ6WXfm_d80nSIdI9GwP0686raZNs8wfyxtaG_lKCWddvJD4nAD_9-FebFVULF4Y4Y8wInHE4XCXecNOCL2k4xIuaBbTs9sMegIC7WbSxfgC-EpHN-8Zwm3BDruwSlTjF24Ifk',
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
              // Notification Bell with absolute badge dot
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainer,
                    ),
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.notifications,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.background,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Radial Ambient Glow Blob
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
