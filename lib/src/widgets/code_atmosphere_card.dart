import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:flutter/material.dart';

/// Decorative atmospheric card that mimics a dark code-editor screenshot.
/// Used as a visual divider / mood element on the language-selection page.
/// Renders a pure-Flutter cyberpunk aesthetic — no external images needed.
class CodeAtmosphereCard extends StatelessWidget {
  const CodeAtmosphereCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Dark gradient base ──────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D1B2A),
                  Color(0xFF0A0F1E),
                  Color(0xFF080B14),
                ],
              ),
            ),
          ),

          // ── Cyan ambient glow left ──────────────────────────────────
          Positioned(
            left: -20,
            top: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryFixedDim.withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Purple glow right ───────────────────────────────────────
          Positioned(
            right: -10,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Syntax-highlighted code lines ───────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _codeLine(
                  'def invert_tree(node):',
                  AppColors.primaryFixedDim,
                  13,
                ),
                const SizedBox(height: 4),
                _codeLine(
                  '    if not node: return None',
                  AppColors.onSurfaceVariant.withValues(alpha: 0.55),
                  13,
                  indent: 16,
                ),
                const SizedBox(height: 4),
                _codeLine(
                  '    node.left, node.right =',
                  AppColors.tertiaryFixed.withValues(alpha: 0.7),
                  13,
                  indent: 16,
                ),
                const SizedBox(height: 4),
                _codeLine(
                  '        node.right, node.left',
                  AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                  12,
                  indent: 28,
                ),
                const SizedBox(height: 4),
                _codeLine(
                  '    return node  # 🌲',
                  AppColors.secondary.withValues(alpha: 0.5),
                  12,
                  indent: 16,
                ),
              ],
            ),
          ),

          // ── Bottom gradient fade to background ──────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeLine(String text, Color color, double size, {double indent = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: Text(
        text,
        style: AppText.labelCode.copyWith(fontSize: size, color: color),
      ),
    );
  }
}
