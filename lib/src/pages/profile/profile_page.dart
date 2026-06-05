import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/grid_dot_background.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: GridDotBackground()),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Profile',
                  style: AppText.headlineMd.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 24),

                // Profile Avatar/Info Card
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceContainerHigh,
                          border: Border.all(
                            color: AppColors.primaryFixedDim.withValues(
                              alpha: 0.4,
                            ),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.primaryFixedDim,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Algorithm Ascender',
                        style: AppText.headlineMd.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'member since June 2026',
                        style: AppText.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Settings List
                Text(
                  'ACCOUNT SETTINGS',
                  style: AppText.labelCaps.copyWith(
                    color: AppColors.primaryFixedDim,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingsTile(Icons.person_outline, 'Edit Profile'),
                _buildSettingsTile(
                  Icons.notifications_none,
                  'Notification Settings',
                ),
                _buildSettingsTile(Icons.security, 'Security & Privacy'),
                _buildSettingsTile(Icons.help_outline, 'Help & Support'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.onSurfaceVariant, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: AppText.bodyMd.copyWith(fontSize: 15)),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.onSurfaceVariant,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
