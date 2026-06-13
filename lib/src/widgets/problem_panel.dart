import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class ProblemPanel extends StatefulWidget {
  final String difficulty;
  final String topics;
  final String descriptionText;
  final String exampleInput;
  final String exampleOutput;

  const ProblemPanel({
    super.key,
    required this.difficulty,
    required this.topics,
    required this.descriptionText,
    required this.exampleInput,
    required this.exampleOutput,
  });

  @override
  State<ProblemPanel> createState() => _ProblemPanelState();
}

class _ProblemPanelState extends State<ProblemPanel> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Difficulty Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      widget.difficulty,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Topics
                  Text(
                    widget.topics,
                    style: AppText.labelCode.copyWith(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              // Show/Hide Toggle Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? 'Hide' : 'Show',
                      style: AppText.labelCaps.copyWith(
                        fontSize: 10,
                        color: AppColors.primaryFixedDim,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.primaryFixedDim,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Problem Description (Animated Collapse)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Problem Description paragraphs (RichText supporting inline code styling)
                      RichText(
                        text: TextSpan(
                          style: AppText.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Given an array of integers ',
                            ),
                            TextSpan(
                              text: 'nums',
                              style: AppText.labelCode.copyWith(
                                color: AppColors.primaryFixedDim,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const TextSpan(
                              text: ' and an integer ',
                            ),
                            TextSpan(
                              text: 'target',
                              style: AppText.labelCode.copyWith(
                                color: AppColors.primaryFixedDim,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const TextSpan(
                              text: ', return indices of the two numbers such that they add up to ',
                            ),
                            TextSpan(
                              text: 'target',
                              style: AppText.labelCode.copyWith(
                                color: AppColors.primaryFixedDim,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Example card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Example 1:',
                              style: AppText.labelCode.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tertiaryFixed,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Input: nums = ${widget.exampleInput}',
                              style: AppText.labelCode.copyWith(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Output: ${widget.exampleOutput}',
                              style: AppText.labelCode.copyWith(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
