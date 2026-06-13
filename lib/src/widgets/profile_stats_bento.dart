import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/services/preferences_service.dart';

class ProfileStatsBento extends StatelessWidget {
  const ProfileStatsBento({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService.instance;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.35,
      children: [
        // Solved
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.terminal,
                    color: AppColors.primaryFixedDim,
                    size: 20,
                  ),
                  Text(
                    'SOLVED',
                    style: AppText.labelCaps,
                  ),
                ],
              ),
              Text(
                '${prefs.solvedCount}',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),

        // Streak (Accent left border)
        _buildStreakCard(),

        // Wakes
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.alarm_on,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                  Text(
                    'WAKES',
                    style: AppText.labelCaps,
                  ),
                ],
              ),
              Text(
                '${prefs.wakesCount}',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),

        // Avg Time
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.timer,
                    color: Color(0xFF849495),
                    size: 20,
                  ),
                  Text(
                    'AVG TIME',
                    style: AppText.labelCaps,
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    height: 1.0,
                  ),
                  children: [
                    TextSpan(text: prefs.avgTime),
                    TextSpan(
                      text: ' min',
                      style: AppText.labelCode.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
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
    );
  }

  Widget _buildStreakCard() {
    final r = BorderRadius.circular(12);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: r,
        border: Border(
          left: const BorderSide(color: AppColors.tertiaryFixedDim, width: 2.5),
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1),
          right: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1),
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08), width: 1),
        ),
      ),
      child: ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: AppColors.tertiaryFixedDim,
                      size: 20,
                    ),
                    Text(
                      'STREAK',
                      style: AppText.labelCaps,
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tertiaryFixedDim,
                      height: 1.0,
                    ),
                    children: [
                      TextSpan(text: '${PreferencesService.instance.streak}'),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: 'days',
                        style: AppText.labelCode.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
