import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/cta_footer.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';
import 'package:algo_rise/src/widgets/neon_cta_footer.dart';
import 'package:algo_rise/src/widgets/onboarding_header.dart';
import 'package:algo_rise/src/widgets/onboarding_page_body.dart';
import 'package:algo_rise/src/widgets/onboarding_scaffold.dart';
import 'package:algo_rise/src/widgets/pressable.dart';
import 'package:flutter/material.dart';

class _QuizQuestion {
  final String number;
  final String question;
  final List<String> options;
  final String? codeSnippet;
  final bool isCodeOptions;

  const _QuizQuestion({
    required this.number,
    required this.question,
    required this.options,
    this.codeSnippet,
    this.isCodeOptions = false,
  });
}

const _questions = [
  _QuizQuestion(
    number: '01',
    question: 'What is the time complexity of accessing an element in an Array by index?',
    options: ['O(1)', 'O(n)', 'O(log n)'],
    isCodeOptions: true,
  ),
  _QuizQuestion(
    number: '02',
    question: 'Predict the output of the following stack operations:',
    codeSnippet: 'list.push(5);\nlist.push(10);\nlist.pop();\nlist.peek();',
    options: ['5', '10', 'null'],
  ),
  _QuizQuestion(
    number: '03',
    question: 'A Linked List is better than an Array for...',
    options: [
      'Constant-time random access by index',
      'Frequent insertions/deletions at the beginning',
      'Better memory locality and cache performance',
    ],
  ),
  _QuizQuestion(
    number: '04',
    question: 'Identify the base case in this recursive function:',
    codeSnippet: 'function fact(n) {\n  if (n <= 1) return 1;\n  return n * fact(n - 1);\n}',
    options: ['n <= 1', 'fact(n - 1)'],
    isCodeOptions: true,
  ),
  _QuizQuestion(
    number: '05',
    question: 'Which data structure uses LIFO (Last-In-First-Out)?',
    options: ['Queue', 'Stack'],
  ),
];

class DiagnosticQuizPage extends StatefulWidget {
  final VoidCallback? onNext;

  const DiagnosticQuizPage({super.key, this.onNext});

  @override
  State<DiagnosticQuizPage> createState() => _DiagnosticQuizPageState();
}

class _DiagnosticQuizPageState extends State<DiagnosticQuizPage>
    with SingleTickerProviderStateMixin {
  final Map<int, int> _selectedAnswers = {};
  late AnimationController _pulse;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      headerHeight: 80,
      header: OnboardingHeader(
        step: 4,
        total: 11,
        center: Opacity(
          opacity: 0.6,
          child: Text(
            'QUICK CHECK',
            style: AppText.labelCaps.copyWith(color: AppColors.primaryFixed),
          ),
        ),
      ),
      body: OnboardingPageBody(
        maxWidth: 1024,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Assess Your Fundamentals', style: AppText.displayMobile),
            const SizedBox(height: 8),
            Text(
              'Skip topics you already know. We\'ll use this to calibrate your starting point and personalize your learning path.',
              style: AppText.bodyLg,
            ),
            const SizedBox(height: 32),

            // Quiz list
            ..._questions.asMap().entries.map((entry) {
              final qIdx = entry.key;
              final q = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: _buildQuestionCard(qIdx, q),
              );
            }),

            const SizedBox(height: 16),
            // Bottom Skip Link
            Center(
              child: TextButton(
                onPressed: widget.onNext,
                child: Text(
                  'Skip and start as beginner',
                  style: AppText.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      cta: CtaFooter(
        subLabel: '${_selectedAnswers.length}/5 Questions Answered',
        button: NeonCtaButton(
          label: 'Submit Assessment',
          height: 64,
          enabled: _selectedAnswers.isNotEmpty,
          pulseAnim: _pulseAnim,
          onTap: widget.onNext,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int qIdx, _QuizQuestion q) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Question Number Badge & Text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  q.number,
                  style: AppText.labelCode.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryFixedDim,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  q.question,
                  style: AppText.bodyLg.copyWith(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Code Snippet if present
          if (q.codeSnippet != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                  left: BorderSide(color: AppColors.secondary, width: 4),
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  q.codeSnippet!,
                  style: AppText.labelCode.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
          ],

          // Options layout
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;

              if (q.options.length == 3 && q.isCodeOptions && isWide) {
                // Problem 1: Grid of 3 columns
                final btnWidth = (constraints.maxWidth - 16) / 3;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: q.options.asMap().entries.map((optEntry) {
                    final optIdx = optEntry.key;
                    final optionText = optEntry.value;
                    return SizedBox(
                      width: btnWidth,
                      child: _buildOptionButton(qIdx, optIdx, optionText, q.isCodeOptions),
                    );
                  }).toList(),
                );
              } else if (q.options.length == 2 && isWide) {
                // Problem 4 & 5: Grid of 2 columns
                final btnWidth = (constraints.maxWidth - 8) / 2;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: q.options.asMap().entries.map((optEntry) {
                    final optIdx = optEntry.key;
                    final optionText = optEntry.value;
                    return SizedBox(
                      width: btnWidth,
                      child: _buildOptionButton(qIdx, optIdx, optionText, q.isCodeOptions),
                    );
                  }).toList(),
                );
              } else {
                // Problem 2 & 3: Vertical Stack
                return Column(
                  children: q.options.asMap().entries.map((optEntry) {
                    final optIdx = optEntry.key;
                    final optionText = optEntry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildOptionButton(qIdx, optIdx, optionText, q.isCodeOptions),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(int qIdx, int optIdx, String text, bool isCode) {
    final isSelected = _selectedAnswers[qIdx] == optIdx;

    return Pressable(
      onTap: () {
        setState(() {
          _selectedAnswers[qIdx] = optIdx;
        });
      },
      scaleDown: 0.98,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withOpacity(0.08)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.outlineVariant,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: isCode
                    ? AppText.labelCode.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.onSurface,
                      )
                    : AppText.bodyMd.copyWith(
                        color: isSelected ? AppColors.primary : AppColors.onSurface,
                      ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle,
                color: AppColors.secondary,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
