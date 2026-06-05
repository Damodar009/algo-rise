import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';

class TopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onAddPressed;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const TopBar({
    Key? key,
    this.title = 'Alarms',
    this.onAddPressed,
    this.avatarUrl,
    this.onAvatarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return ClipRect(
      child: Container(
        height: top + 56,
        padding: EdgeInsets.only(top: top, left: 16, right: 16),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.85),
          border: const Border(
            bottom: BorderSide(color: Colors.white10, width: 1),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppText.bodyMd.copyWith(color: AppColors.primary),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onAddPressed,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.primaryFixedDim,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContHigh,
                        border: Border.all(color: Colors.white10),
                      ),
                      child: avatarUrl != null
                          ? ClipOval(
                              child: Image.network(
                                avatarUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 20,
                              color: AppColors.onSurfaceVariant,
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
}
