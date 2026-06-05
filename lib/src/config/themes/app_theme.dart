import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';
import 'app_text.dart';

/// AlgoRise ThemeData — built on top of AppColors + AppText.
/// Usage:
///   MaterialApp(
///     theme:      AppTheme.light,
///     darkTheme:  AppTheme.dark,
///   )
class AppTheme {
  AppTheme._();

  // ── Public entry points ──────────────────────────────────────────────────
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  // ── Core builder ─────────────────────────────────────────────────────────
  static ThemeData _build(Brightness brightness) {
    final isLight = brightness == Brightness.light;

    // Background / surface
    final Color bgColor = isLight ? Colors.white : AppColors.background;
    final Color surfaceColor = isLight ? Colors.white : AppColors.surface;
    final Color onSurface = isLight
        ? AppColors.background
        : AppColors.onSurface;
    final Color mutedText = onSurface.withOpacity(isLight ? 0.7 : 0.8);

    // Accent colours — reuse AlgoRise tokens
    // primary   → primaryFixedDim  (cyan #00DCE5) — main interactive colour
    // secondary → primary          (near-white #E9FEFF) — secondary label colour
    // error     → error            (#FFB4AB)
    const Color primary = AppColors.primaryFixedDim;
    const Color secondary =
        AppColors.primaryFixed; // #63F7FF — slightly brighter cyan
    const Color error = AppColors.error;

    final ColorScheme colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: AppColors.onPrimaryFixed, // dark teal #002021
      secondary: secondary,
      onSecondary: AppColors.onPrimaryFixed,
      error: error,
      onError: AppColors.background,
      surface: surfaceColor,
      onSurface: onSurface,
    );

    final textTheme = _buildTextTheme(onSurface);

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bgColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Outfit', // AlgoRise primary font
      textTheme: textTheme,

      // ── AppBar ────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        shadowColor: Colors.transparent,
        backgroundColor: surfaceColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: onSurface),
        actionsIconTheme: IconThemeData(color: onSurface),
        titleTextStyle: AppText.headlineMd.copyWith(
          fontFamily: 'Outfit',
          fontSize: 22,
          color: onSurface,
        ),
      ),

      // ── Input decoration ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? surfaceColor : AppColors.inputBg,
        labelStyle: textTheme.bodyLarge,
        floatingLabelStyle: textTheme.bodyLarge,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w400,
        ),
        counterStyle: textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: colorScheme.primary,
        ),
        errorStyle: textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: colorScheme.error,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(
            color: AppColors.outlineVariant.withOpacity(0.5),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
      ),

      // ── Elevated button (primary action) ──────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          textStyle: textTheme.labelLarge,
          elevation: 0,
          foregroundColor: AppColors.onPrimaryFixed,
          backgroundColor: colorScheme.primary, // cyan
          disabledBackgroundColor: AppColors.surfaceContainerHighest,
          disabledForegroundColor: AppColors.onSurfaceVariant,
        ),
      ),

      // ── Outlined button ───────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          textStyle: textTheme.labelLarge,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          disabledForegroundColor: mutedText,
          side: BorderSide(color: colorScheme.primary),
        ),
      ),

      // ── Text button ───────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          textStyle: textTheme.labelLarge,
          foregroundColor: colorScheme.primary,
          disabledForegroundColor: mutedText,
        ),
      ),

      // ── Chip ──────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        side: const BorderSide(color: Colors.transparent),
        backgroundColor: AppColors.surfaceContainerHigh,
        labelStyle: textTheme.bodyMedium!,
      ),

      // ── Divider ───────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: AppColors.outlineVariant.withOpacity(isLight ? 0.5 : 0.3),
      ),

      // ── Bottom nav bar ────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: surfaceColor,
        selectedLabelStyle: textTheme.bodyLarge,
        unselectedLabelStyle: textTheme.bodyMedium,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: mutedText,
      ),

      // ── Bottom sheet ──────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        surfaceTintColor: surfaceColor,
      ),

      // ── Date picker ───────────────────────────────────────────────────
      datePickerTheme: DatePickerThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        surfaceTintColor: surfaceColor,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: AppColors.onPrimaryFixed,
        headerHelpStyle: AppText.labelCode.copyWith(
          fontSize: 14,
          color: AppColors.onPrimaryFixed,
        ),
        weekdayStyle: AppText.labelCaps.copyWith(
          fontSize: 14,
          color: onSurface,
        ),
        dayStyle: AppText.labelCode.copyWith(fontSize: 14, color: onSurface),
      ),

      // ── List tile ─────────────────────────────────────────────────────
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: -20,
      ),
    );
  }

  // ── TextTheme ────────────────────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color onSurface) {
    return TextTheme(
      // displayLarge  → hero headline (Outfit 36 bold)
      displayLarge: AppText.displayMobile.copyWith(color: onSurface),

      // displayMedium → section headline (Outfit 24 semibold)
      displayMedium: AppText.headlineMd.copyWith(color: onSurface),

      // titleLarge    → app bar / card title (Outfit 22 bold)
      titleLarge: AppText.headlineMd.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),

      // bodyLarge     → bold body (Inter 18 bold)
      bodyLarge: AppText.bodyLg.copyWith(
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),

      // bodyMedium    → regular body (Inter 16 regular)
      bodyMedium: AppText.bodyMd.copyWith(color: onSurface),

      // labelLarge    → button / caps label (JetBrains Mono 12 bold)
      labelLarge: AppText.labelCaps.copyWith(
        fontSize: 14,
        letterSpacing: 0,
        color: onSurface,
      ),

      // labelMedium   → code/mono label (JetBrains Mono 14 medium)
      labelMedium: AppText.labelCode.copyWith(color: onSurface),
    );
  }
}
