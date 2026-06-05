import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color background;
  final double size;
  final double iconSize;

  const IconBox({
    super.key,
    required this.icon,
    required this.color,
    this.background = AppColors.surfaceContainerHigh,
    this.size = 48,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Center(
      child: Icon(icon, size: iconSize, color: color),
    ),
  );
}
