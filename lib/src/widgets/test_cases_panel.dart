import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';

class TestCaseResult {
  final String input;
  final String expected;
  final String actual;
  final bool passed;

  TestCaseResult({
    required this.input,
    required this.expected,
    required this.actual,
    required this.passed,
  });
}

class TestCasesPanel extends StatefulWidget {
  final bool hasSyntaxError;
  final String syntaxErrorMessage;
  final List<TestCaseResult> results;
  final String runtime;
  final String memory;

  const TestCasesPanel({
    super.key,
    required this.hasSyntaxError,
    required this.syntaxErrorMessage,
    required this.results,
    this.runtime = '32 ms',
    this.memory = '14.2 MB',
  });

  @override
  State<TestCasesPanel> createState() => _TestCasesPanelState();
}

class _TestCasesPanelState extends State<TestCasesPanel> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final bool allPassed = !widget.hasSyntaxError && widget.results.every((r) => r.passed);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: const Border(
          top: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title / Verdict Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.hasSyntaxError
                    ? 'COMPILE ERROR'
                    : (allPassed ? 'ACCEPTED' : 'WRONG ANSWER'),
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.hasSyntaxError
                      ? AppColors.error
                      : (allPassed ? AppColors.tertiaryFixedDim : AppColors.error),
                ),
              ),
              if (!widget.hasSyntaxError)
                Row(
                  children: [
                    Text(
                      'Runtime: ${widget.runtime}',
                      style: AppText.labelCode.copyWith(fontSize: 12),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Memory: ${widget.memory}',
                      style: AppText.labelCode.copyWith(fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Content body
          if (widget.hasSyntaxError)
            // Error Stack display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                widget.syntaxErrorMessage,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 13,
                  color: AppColors.error,
                ),
              ),
            )
          else ...[
            // Tab selectors
            Row(
              children: List.generate(widget.results.length, (index) {
                final result = widget.results[index];
                final isActive = _activeTab == index;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeTab = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.surfaceContainerHigh
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive
                              ? AppColors.primaryFixedDim.withValues(alpha: 0.25)
                              : Colors.white10,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            result.passed ? Icons.check_circle : Icons.cancel,
                            size: 14,
                            color: result.passed ? AppColors.tertiaryFixedDim : AppColors.error,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Case ${index + 1}',
                            style: AppText.labelCode.copyWith(
                              fontSize: 12,
                              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Tab Details Card
            _buildTabDetails(widget.results[_activeTab]),
          ],
          const SizedBox(height: 20),

          // Close button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'CLOSE CONSOLE',
                style: AppText.labelCaps.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 13,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabDetails(TestCaseResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Input:', result.input, AppColors.onSurface),
        const SizedBox(height: 12),
        _buildDetailRow(
          'Output:',
          result.actual,
          result.passed ? AppColors.tertiaryFixedDim : AppColors.error,
        ),
        const SizedBox(height: 12),
        _buildDetailRow('Expected:', result.expected, AppColors.onSurfaceVariant),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.labelCaps.copyWith(
            fontSize: 10,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 13,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
