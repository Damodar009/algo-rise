import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class PreferencesList extends StatelessWidget {
  const PreferencesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              const Icon(
                Icons.settings,
                color: AppColors.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'PREFERENCES',
                style: AppText.labelCaps.copyWith(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Menu List in GlassCard
        GlassCard(
          padding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.notifications_active,
                iconColor: AppColors.primaryFixedDim,
                title: 'Notification Settings',
                onTap: () {},
              ),
              const Divider(height: 1, color: Colors.white10, thickness: 1),
              _buildMenuItem(
                icon: Icons.manage_accounts,
                iconColor: AppColors.primaryFixedDim,
                title: 'Account',
                onTap: () {},
              ),
              const Divider(height: 1, color: Colors.white10, thickness: 1),
              _buildMenuItem(
                icon: Icons.logout,
                iconColor: AppColors.error,
                title: 'Logout',
                titleColor: AppColors.error,
                trailing: Text(
                  'v2.4.1',
                  style: AppText.labelCode.copyWith(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: AppText.bodyMd.copyWith(
                  color: titleColor ?? AppColors.onSurface,
                  fontSize: 15,
                ),
              ),
            ),
            trailing ??
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
