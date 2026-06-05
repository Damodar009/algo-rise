import 'dart:ui';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final bool isActive;
  final Color? activeColor;
  final Clip clipBehavior;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.isActive = false,
    this.activeColor,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    final c = activeColor ?? AppColors.primaryFixedDim;
    final r = borderRadius ?? BorderRadius.circular(12);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      clipBehavior: clipBehavior == Clip.none ? Clip.antiAlias : clipBehavior,
      decoration: BoxDecoration(
        color: isActive
            ? c.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.04),
        borderRadius: r,
        border: Border.all(
          color: isActive ? c : Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        boxShadow: isActive
            ? [BoxShadow(color: c.withValues(alpha: 0.15), blurRadius: 20)]
            : [],
      ),
      child: ClipRRect(
        borderRadius: r,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

