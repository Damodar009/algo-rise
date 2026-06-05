import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/widgets/alarm_card.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/image_paceholder.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/services/alarm_service.dart';
import 'package:algo_rise/src/models/alarm_data.dart';


class AlarmsPage extends StatefulWidget {
  final bool isNested;
  const AlarmsPage({super.key, this.isNested = false});

  @override
  State<AlarmsPage> createState() => _AlarmsPageState();
}

class _AlarmsPageState extends State<AlarmsPage> with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _glowCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _glowAnim;
  late Animation<double> _fadeIn;
  late AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    AlarmService.instance.loadAlarms();

    // Pulse glow on empty illustration
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.15,
      end: 0.35,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // CTA button glow
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(
      begin: 10,
      end: 24,
    ).animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    // Entry fade + slide
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _glowCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AlarmData>>(
      valueListenable: AlarmService.instance.alarmsNotifier,
      builder: (context, alarms, child) {
        if (alarms.isEmpty) {
          return _buildEmptyState();
        }
        return _buildAlarmsList(alarms);
      },
    );
  }

  Widget _buildAlarmsList(List<AlarmData> alarms) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B14),
      appBar: AppBar(
        backgroundColor: AppColors.background.withValues(alpha: 0.8),
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuB6S-BGXKTg_14SDj-NGsNc1MiL1Z7pQ1h2QycAyGRsE0-lUkaU0Yb_xyrhXdbqvbSaeK-p6CiQT_4LHugc10e_Z4EzQ_ZedkyROdfpgYWi_MSrvNEASCM6e2pRUMKH63I4o9OjOj8MokQ_vExdjKkRi9In4_64nqSL7WmTd5gwGyY6IUL4XNpC5izdOquKAdhUyhLxkPgvqK3qxSXyvQ2h4xxFEmMyxDHFp8olBJ-z6nMDT0zkDaxw9a82hGNJP7XOCheaPCEOYpTe',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'AlgoRise',
              style: AppText.headlineMd.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryFixedDim,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primaryFixedDim, size: 28),
            onPressed: () => context.push('/alarm/create'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: 20,
            right: -80,
            child: Container(
              width: 256,
              height: 256,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixedDim.withValues(alpha: 0.03),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 96),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alarms Title Row with Streak Chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alarms',
                            style: AppText.headlineMd.copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Stay sharp, stay consistent.',
                            style: AppText.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryFixedDim.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppColors.tertiaryFixedDim.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: AppColors.tertiaryFixedDim,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '12 DAY STREAK',
                              style: AppText.labelCaps.copyWith(
                                fontSize: 9,
                                color: AppColors.tertiaryFixedDim,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Alarm Cards
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: alarms.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final alarm = alarms[index];
                      return Dismissible(
                        key: ValueKey(alarm.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.errorContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.delete, color: AppColors.error),
                        ),
                        onDismissed: (_) {
                          AlarmService.instance.removeAlarm(alarm.id);
                        },
                        child: AlarmCard(
                          time: alarm.time,
                          period: alarm.period,
                          repeatDays: alarm.repeatDays,
                          active: alarm.active,
                          mode: alarm.mode,
                          language: alarm.language,
                          tags: alarm.tags,
                          themeColor: alarm.themeColor,
                          onToggle: (newVal) {
                            AlarmService.instance.toggleAlarmActive(alarm.id, newVal);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Bento Suggestion Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixedDim.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.primaryFixedDim,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Optimize your sleep',
                                style: AppText.headlineMd.copyWith(
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Recommended: 10:45 PM Bedtime',
                                style: AppText.bodyMd.copyWith(
                                  fontSize: 13,
                                  color: AppColors.onSurfaceVariant,
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
          ),
        ],
      ),
    );
  }

  // ─── Empty State Widget (Conditional) ─────────────────────────────────────
  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primaryFixedDim, size: 28),
            onPressed: () => context.push('/alarm/create'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(_fadeIn),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    AnimatedBuilder(
                      animation: _pulseAnim,
                      builder: (context, child) {
                        return Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withValues(alpha: 0.04),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryFixedDim.withValues(
                                  alpha: _pulseAnim.value,
                                ),
                                blurRadius: 60,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'assets/images/empty_robot.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const RobotPlaceholder(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Headline
                    Text(
                      'No alarms yet.',
                      style: AppText.bodyMd.copyWith(color: AppColors.primaryFixedDim),
                    ),
                    const SizedBox(height: 8),

                    // Subtext
                    SizedBox(
                      width: 240,
                      child: Text(
                        "Your streak won't start itself. Set a wake-up time to begin your ascent.",
                        textAlign: TextAlign.center,
                        style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Streak Chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: AppColors.tertiaryFixedDim,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          RichText(
                            text: TextSpan(
                              style: AppText.labelCode.copyWith(
                                color: AppColors.tertiaryFixed,
                              ),
                              children: const [
                                TextSpan(text: 'CURRENT STREAK: '),
                                TextSpan(
                                  text: '0 DAYS',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // CTA Button
                    NeonCtaButton(
                      label: 'Set First Alarm',
                      height: 56,
                      pulseAnim: _glowAnim,
                      onTap: () {
                        context.push('/alarm/create');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
