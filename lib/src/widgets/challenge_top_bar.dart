import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';

class ChallengeTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String timeText;
  final String hintCostText;
  final List<Widget>? actions;

  const ChallengeTopBar({
    super.key,
    required this.title,
    this.timeText = '14:32',
    this.hintCostText = '-5 XP',
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: preferredSize.height + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 16,
            right: 16,
          ),
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
              // Terminal Icon & Title
              const Icon(
                Icons.terminal,
                color: AppColors.primaryFixedDim,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppText.headlineMd.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),

              // Timer Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: AppColors.primaryFixedDim,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timeText,
                      style: AppText.labelCode.copyWith(
                        fontSize: 12,
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Hint Badge
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lightbulb,
                    color: AppColors.error,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hintCostText,
                    style: AppText.labelCode.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
              if (actions != null) ...[
                const SizedBox(width: 8),
                ...actions!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
