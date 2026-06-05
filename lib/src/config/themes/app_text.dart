import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

/// Central typography — mirrors the AlgoRise Tailwind font-size tokens.
abstract class AppText {
  /// Outfit 36/44 bold — mobile hero headline
  static const displayMobile = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 36,
    height: 44 / 36,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  /// Outfit 24/32 semibold — section headline
  static const headlineMd = TextStyle(
    fontFamily: 'Outfit',
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  /// Inter 18/28 regular — body large
  static const bodyLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    height: 28 / 18,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurfaceVariant,
  );

  /// Inter 16/24 regular — body medium
  static const bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.onSurface,
  );

  /// JetBrains Mono 12/16 bold CAPS — step labels, badges
  static const labelCaps = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: AppColors.onSurfaceVariant,
  );

  /// JetBrains Mono 14/20 medium — code snippets, inputs
  static const labelCode = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );
}
