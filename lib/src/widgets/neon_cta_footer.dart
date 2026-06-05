import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

/// Full-width primary action button with a pulsing neon glow and press-scale animation.
///
/// - Supply [pulseAnim] from a parent controller to synchronise timing.
/// - When [enabled] is false the button renders in a muted disabled style.
/// - [color] overrides the default [AppColors.primaryFixedDim] fill.
class NeonCtaButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool enabled;
  final double height;
  final Color? color;
  final Animation<double>? pulseAnim;

  const NeonCtaButton({
    super.key,
    this.label = 'Continue',
    this.onTap,
    this.enabled = true,
    this.height = 56,
    this.color,
    this.pulseAnim,
  });

  @override
  State<NeonCtaButton> createState() => _NeonCtaButtonState();
}

class _NeonCtaButtonState extends State<NeonCtaButton>
    with TickerProviderStateMixin {
  late AnimationController _press;
  late Animation<double> _scale;
  AnimationController? _ownPulse;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _press, curve: Curves.easeOut));

    if (widget.pulseAnim == null) {
      _ownPulse = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
      )..repeat(reverse: true);
      _pulse = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _ownPulse!, curve: Curves.easeInOut));
    } else {
      _pulse = widget.pulseAnim!;
    }
  }

  @override
  void dispose() {
    _press.dispose();
    _ownPulse?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final btnColor = widget.color ?? AppColors.primaryFixedDim;

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _press.forward() : null,
      onTapUp: widget.enabled
          ? (_) {
              _press.reverse();
              widget.onTap?.call();
            }
          : null,
      onTapCancel: widget.enabled ? () => _press.reverse() : null,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) {
            final glow = widget.enabled ? 0.20 + _pulse.value * 0.20 : 0.0;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.enabled
                    ? btnColor
                    : AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: btnColor.withValues(alpha: glow),
                    blurRadius: 20 + _pulse.value * 8,
                  ),
                ],
              ),
              child: Opacity(
                opacity: widget.enabled ? 1.0 : 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.label,
                      style: AppText.headlineMd.copyWith(
                        color: widget.enabled
                            ? AppColors.onPrimaryFixed
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 24,
                      color: widget.enabled
                          ? AppColors.onPrimaryFixed
                          : AppColors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
