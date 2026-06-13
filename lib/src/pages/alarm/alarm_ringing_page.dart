import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:go_router/go_router.dart';

class AlarmRingingPage extends StatefulWidget {
  const AlarmRingingPage({super.key});

  @override
  State<AlarmRingingPage> createState() => _AlarmRingingPageState();
}

class _AlarmRingingPageState extends State<AlarmRingingPage>
    with TickerProviderStateMixin {
  // Animation controllers
  late final AnimationController _ringsController;
  late final AnimationController _bellController;
  late final AnimationController _breathingController;

  // Staggered ring offsets
  final List<double> _ringOffsets = [0.0, 0.25, 0.5, 0.75];

  @override
  void initState() {
    super.initState();

    // 1. Controller for staggered background rings
    _ringsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // 2. Controller for bell shake + scale pulse
    _bellController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // 3. Controller for breathing text opacity
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ringsController.dispose();
    _bellController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B14),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Immersive Imagery (Decorative blur gradients)
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Color(0xFF641FAC), // purple accent
                      Color(0xFF080B14), // background
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Alarm Title / Ringing Content (Centered in top portion above bottom sheet)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: MediaQuery.of(context).size.height * 0.55,
            child: SafeArea(
              bottom: false,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Centered Ringing Bell with Wave Animation
                      _buildBellWithRings(),
                      const SizedBox(height: 12),

                      // Time Display
                      Text(
                        '06:30 AM',
                        style: TextStyle(
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Outfit',
                          letterSpacing: -1,
                          shadows: [
                            Shadow(
                              color: AppColors.primaryFixedDim.withValues(alpha: 0.4),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Streak Danger Badge
                      _buildStreakWarning(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. Bottom Sheet Glass Panel (Draggable / Scrollable)
          _buildBottomSheet(context),
        ],
      ),
    );
  }

  // ─── Bell with Waves Centered ─────────────────────────────────────────────
  Widget _buildBellWithRings() {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Rings aligned to bell
          AnimatedBuilder(
            animation: _ringsController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: _ringOffsets.map((offset) {
                  final t = (_ringsController.value + offset) % 1.0;
                  final scale = 0.4 + (t * 1.8);
                  double opacity = (t < 0.2) ? (t / 0.2) : ((1.0 - t) / 0.8);
                  opacity = opacity.clamp(0.0, 1.0);

                  return Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity * 0.25,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: offset % 0.5 == 0
                                ? AppColors.primaryFixedDim
                                : AppColors.secondary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          // Pulsing + Shaking Bell Icon
          _buildAlarmBell(),
        ],
      ),
    );
  }

  // ─── Shaking & Pulsing Alarm Bell ─────────────────────────────────────────
  Widget _buildAlarmBell() {
    return AnimatedBuilder(
      animation: _bellController,
      builder: (context, child) {
        // 1. Shaking angle sequence
        final val = _bellController.value;
        double angle = 0.0;
        if (val < 0.5) {
          // Shaking phase (first 50% of cycle)
          final t = val / 0.5; // normalized 0..1
          // Sine wave shake
          angle = 0.18 * math.sin(t * 4 * math.pi);
        }

        // 2. Pulsing scale
        final scale = 1.0 + (0.08 * math.sin(val * 2 * math.pi));

        return Transform.scale(
          scale: scale,
          child: Transform.rotate(
            angle: angle,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cyan background glow
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryFixedDim.withValues(alpha: 0.2),
                        blurRadius: 24,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
                // Icon
                const Icon(
                  Icons.notifications_active,
                  size: 64,
                  color: AppColors.primaryFixedDim,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Breathing Streak Warning Badge ───────────────────────────────────────
  Widget _buildStreakWarning() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
      ),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: BorderRadius.circular(24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_fire_department,
              color: AppColors.tertiaryFixedDim,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              '🔥 17-day streak at risk!',
              style: AppText.labelCode.copyWith(
                color: AppColors.tertiaryFixedDim,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Elevated Bottom Sheet ───────────────────────────────────────────────
  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                children: [
                  // Drag Handle (Fixed at the top)
                  Center(
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header
                  const Center(
                    child: Text(
                      'WAKE UP, @DEV_USER',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryFixedDim,
                        letterSpacing: 1.5,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Solve to silence the alarm',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Challenge Preview Card (Bento Style Glass Card)
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Invert Binary Tree',
                                  style: AppText.headlineMd.copyWith(
                                    fontSize: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'DAILY ALGORITHM CHALLENGE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'JetBrains Mono',
                                    color: AppColors.onSurfaceVariant,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.secondary.withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Text(
                                'Medium',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Language Tag
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.code,
                                      color: AppColors.primaryFixedDim,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'LANGUAGE',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: AppColors.onSurfaceVariant,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Python',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Duration Tag
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.timer_outlined,
                                      color: AppColors.primaryFixedDim,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'EST. TIME',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: AppColors.onSurfaceVariant,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        '~ 8 min',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons
                  Column(
                    children: [
                       // Start Button
                       GestureDetector(
                         onTap: () {
                           Alarm.stopAll();
                           GoRouter.of(context).go('/challenge');
                         },
                         child: Container(
                           height: 56,
                           decoration: BoxDecoration(
                             color: AppColors.primaryFixedDim,
                             borderRadius: BorderRadius.circular(12),
                             boxShadow: [
                               BoxShadow(
                                 color: AppColors.primaryFixedDim.withValues(
                                   alpha: 0.3,
                                 ),
                                 blurRadius: 16,
                                 offset: const Offset(0, 4),
                               ),
                             ],
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text(
                                 'START CHALLENGE',
                                 style: AppText.headlineMd.copyWith(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                   color: AppColors.onPrimaryFixed,
                                 ),
                               ),
                               const SizedBox(width: 8),
                               const Icon(
                                 Icons.arrow_forward,
                                 color: AppColors.onPrimaryFixed,
                                 size: 20,
                               ),
                             ],
                           ),
                         ),
                       ),
                       const SizedBox(height: 12),
                       // Snooze Button
                       SizedBox(
                         width: double.infinity,
                         height: 56,
                         child: OutlinedButton(
                           onPressed: () async {
                             final activeAlarms = await Alarm.getAlarms();
                             if (activeAlarms.isNotEmpty) {
                               final first = activeAlarms.first;
                               final snoozeSettings = AlarmSettings(
                                 id: first.id,
                                 dateTime: DateTime.now().add(const Duration(minutes: 5)),
                                 assetAudioPath: first.assetAudioPath,
                                 loopAudio: first.loopAudio,
                                 vibrate: first.vibrate,
                                 volumeSettings: first.volumeSettings,
                                 androidFullScreenIntent: first.androidFullScreenIntent,
                                 notificationSettings: first.notificationSettings,
                               );
                               await Alarm.stop(first.id);
                               await Alarm.set(alarmSettings: snoozeSettings);
                             } else {
                               await Alarm.stopAll();
                             }
                             if (context.mounted) {
                                GoRouter.of(context).go('/main');
                              }
                           },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.onSurfaceVariant.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'SNOOZE 5 MIN',
                            style: AppText.labelCaps.copyWith(
                              color: AppColors.onSurface,
                              fontSize: 13,
                              letterSpacing: 1.0,
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
      },
    );
  }
}
