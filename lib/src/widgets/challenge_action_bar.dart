import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class ChallengeActionBar extends StatelessWidget {
  final VoidCallback? onRun;
  final VoidCallback? onSubmit;

  const ChallengeActionBar({
    super.key,
    this.onRun,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.9),
            border: const Border(
              top: BorderSide(color: Colors.white10, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryFixedDim.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // RUN Button
              GestureDetector(
                onTap: onRun,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.play_arrow,
                              color: AppColors.onSurface,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'RUN',
                              style: AppText.labelCaps.copyWith(
                                fontSize: 14,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // SUBMIT Button
              GestureDetector(
                onTap: onSubmit,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixedDim,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryFixedDim,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryFixedDim.withValues(alpha: 0.25),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.send,
                          color: AppColors.onPrimaryFixed,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'SUBMIT',
                          style: AppText.labelCaps.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onPrimaryFixed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
