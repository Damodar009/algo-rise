import 'package:flutter/material.dart';

/// Central color palette — mirrors the AlgoRise Tailwind design tokens.
abstract class AppColors {
  static const background = Color(0xFF080B14);
  static const surface = Color(0xFF10131C);
  static const surfaceContainerLow = Color(0xFF181B25);
  static const surfaceContainer = Color(0xFF1C1F29);
  static const surfaceContainerHigh = Color(0xFF272A34);
  static const surfaceContainerHighest = Color(0xFF32343F);

  static const primary = Color(0xFFE9FEFF);
  static const primaryFixed = Color(0xFF63F7FF);
  static const primaryFixedDim = Color(0xFF00DCE5);
  static const primaryContainer = Color(0xFF00F5FF);
  static const onPrimaryFixed = Color(0xFF002021);
  static const onPrimaryFixedVariant = Color(0xFF004F53);

  static const secondary = Color(0xFFDAB9FF);
  static const tertiaryFixed = Color(0xFF60FF99);
  static const tertiaryFixedDim = Color(0xFF00E479);

  static const error = Color(0xFFFFB4AB);
  static const errorContainer = Color(0xFF93000A);

  static const onSurface = Color(0xFFE0E2EF);
  static const onSurfaceVariant = Color(0xFFB9CACA);
  static const outlineVariant = Color(0xFF3A494A);

  static const inputBg = Color(0xFF0D1117);
  static const gridDot = Color(0xFF1C1F29);

  static const kBackground = Color(0xFF10131C);
  static const kSurface = Color(0xFF10131C);
  static const kSurfaceContainer = Color(0xFF1C1F29);
  static const kSurfaceContHigh = Color(0xFF272A34);
  static const kSurfaceVariant = Color(0xFF32343F);
  static const kPrimary = Color(0xFFE9FEFF);
  static const kPrimaryFixed = Color(0xFF63F7FF);
  static const kPrimaryFixedDim = Color(0xFF00DCE5);
  static const kOnPrimaryFixed = Color(0xFF002021);
  static const kOnSurface = Color(0xFFE0E2EF);
  static const kOnSurfaceVariant = Color(0xFFB9CACA);
  static const kTertiaryFixed = Color(0xFF60FF99);
  static const kTertiaryFixedDim = Color(0xFF00E479);
  static const kTertiary = Color(0xFFEDFFEC);
  static const kOutlineVariant = Color(0xFF3A494A);
  // Alias for legacy name used in code
  static const surfaceContHigh = surfaceContainerHigh;
}
