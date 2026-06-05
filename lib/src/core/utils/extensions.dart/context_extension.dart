import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        Colors,
        FontWeight,
        MediaQuery,
        Offset,
        Shadow,
        Size,
        TextDecoration,
        TextStyle,
        Theme,
        ThemeData;

import '../../../config/themes/colors.dart';

extension BuildContextExtension<T> on BuildContext {
  /*------------------ sizes --------------*/

  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  Size get responsiveSize => MediaQuery.of(this).size;

  ThemeData get theme => Theme.of(this);

  bool get isSmallDevice => height < 650.0 && height >= 500.0;

  /*------------------ text theme --------------*/

  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;

  TextStyle? get displayLarge => Theme.of(this).textTheme.displayLarge;

  TextStyle? get displayMedium => Theme.of(this).textTheme.displayMedium;

  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;

  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;

  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;
  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;

  Color? get primaryColor => Theme.of(this).colorScheme.primary;

  Color? get secondaryColor => Theme.of(this).colorScheme.secondary;

  TextStyle? get notificationTitle => titleSmall!.copyWith(
    fontWeight: FontWeight.bold,
    // color: AppColors.fullBlack,
  );

  TextStyle? get headlineLarge =>
      Theme.of(this).textTheme.displayLarge?.copyWith(fontSize: 36);

  TextStyle? get underlineStyle => titleMedium?.copyWith(
    fontSize: 18,
    decoration: TextDecoration.underline,
    height: 1.5,
    shadows: [const Shadow(color: AppColors.secondary, offset: Offset(0, -1))],
    color: Colors.transparent,
    decorationColor: AppColors.secondary,
  );

  TextStyle? get alertMessageStyle => bodyMedium?.copyWith(
    fontSize: 18,
    height: 22 / 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle? get alertStyle =>
      titleLarge?.copyWith(fontWeight: FontWeight.w400, color: AppColors.error);
}
