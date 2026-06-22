import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/models/leetcode_problem.dart';
import 'package:algo_rise/src/widgets/html_text.dart';

class ProblemPanel extends StatefulWidget {
  final String difficulty;
  final String topics;
  final String descriptionText;
  final String exampleInput;
  final String exampleOutput;
  final List<LeetCodeExample>? parsedExamples;

  const ProblemPanel({
    super.key,
    required this.difficulty,
    required this.topics,
    required this.descriptionText,
    required this.exampleInput,
    required this.exampleOutput,
    this.parsedExamples,
  });

  @override
  State<ProblemPanel> createState() => _ProblemPanelState();
}

class _ProblemPanelState extends State<ProblemPanel> {
  bool _isExpanded = true;

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF00B8A3);
      case 'medium':
        return const Color(0xFFFFC01E);
      case 'hard':
        return const Color(0xFFFF375F);
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final diffColor = _getDifficultyColor(widget.difficulty);
    final hasParsedExamples = widget.parsedExamples != null && widget.parsedExamples!.isNotEmpty;

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
                      color: diffColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: diffColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      widget.difficulty,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: diffColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Topics
                  if (widget.topics.isNotEmpty)
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
                      // Parse and render HTML description dynamically
                      HtmlText(html: widget.descriptionText),
                      const SizedBox(height: 16),
                      
                      // Examples Section
                      if (hasParsedExamples) ...[
                        ...widget.parsedExamples!.asMap().entries.map((entry) {
                          final int idx = entry.key;
                          final LeetCodeExample example = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
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
                                    'Example ${idx + 1}:',
                                    style: AppText.labelCode.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.tertiaryFixed,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Input: ${example.input}',
                                    style: AppText.labelCode.copyWith(
                                      fontSize: 12,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Output: ${example.output}',
                                    style: AppText.labelCode.copyWith(
                                      fontSize: 12,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  if (example.explanation != null && example.explanation!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Explanation: ${example.explanation}',
                                      style: AppText.labelCode.copyWith(
                                        fontSize: 12,
                                        color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                      ] else ...[
                        // Fallback to legacy single example fields
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
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
