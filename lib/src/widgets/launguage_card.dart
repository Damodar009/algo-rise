import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'pressable.dart';

/// A 2-column language selection card used on the "What language do you think in?" page.
/// Shows an icon box, language name, version badge, and an animated check indicator.
class LanguageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String version;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCard({
    super.key,
    required this.icon,
    required this.title,
    required this.version,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scaleDown: 0.97,
      child: GlassCard(
        isActive: isSelected,
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon box
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryContainer.withValues(alpha: 0.10)
                        : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 28,
                      color: isSelected
                          ? AppColors.primaryFixedDim
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Language name
                Text(
                  title,
                  style: AppText.headlineMd.copyWith(
                    fontSize: 18,
                    color: isSelected ? AppColors.primary : AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                // Version badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    version,
                    style: AppText.labelCode.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),

            // Check circle — top-right, fades in when selected
            Positioned(
              top: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.check_circle,
                  size: 24,
                  color: AppColors.primaryFixedDim,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
