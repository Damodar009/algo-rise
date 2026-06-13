import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/services/preferences_service.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar with gradient border and glow
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Glow backdrop
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryFixedDim.withValues(alpha: 0.25),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              // Gradient ring container
              Container(
                width: 88,
                height: 88,
                padding: const EdgeInsets.all(3), // Border thickness equivalent
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      AppColors.primaryFixedDim,
                      AppColors.secondary,
                    ],
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF0B0E17),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAfs9XosLh_POXVpbbt3LBKG9C3gRK_63tK_BAtjlOcMqOaQeKR0Mofo4KvDCK7VNcv4fw-s_fsUa5e5teTKi5HYqgB4S20VTl2uy9Y7u9UDhr1u96PAAW8eyaMLo443tp1FZmrR3iIC6QNO6tnu68icU5CJl6NSMT_Xmo495cZleGugpXzNxw7ldJ8JQgIPQ6EcKsFPzk8Bl0lukP0Ng7MQXlIECbm3NUqa59HyIresVOqiNrQ4VAyKyQ-U_ZJ7BGEuchpqD3HJq6E',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        color: AppColors.onSurfaceVariant,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              // LVL Badge at bottom-right
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.background,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    'LVL ${PreferencesService.instance.totalXp ~/ 50}',
                    style: AppText.labelCaps.copyWith(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimaryFixed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Username and Rank info
        Text(
          '@dev_user',
          style: AppText.headlineMd.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified,
              color: AppColors.primaryFixedDim,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Code Warrior'.toUpperCase(),
              style: AppText.labelCode.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryFixedDim,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
