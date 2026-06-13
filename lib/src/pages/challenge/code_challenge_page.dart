import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/go.dart';
import 'package:highlight/languages/rust.dart';
import 'package:highlight/languages/javascript.dart';

import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/widgets/challenge_top_bar.dart';
import 'package:algo_rise/src/widgets/problem_panel.dart';
import 'package:algo_rise/src/widgets/code_editor_area.dart';
import 'package:algo_rise/src/widgets/editor_toolbar.dart';
import 'package:algo_rise/src/widgets/challenge_action_bar.dart';
import 'package:algo_rise/src/widgets/test_cases_panel.dart';
import 'package:algo_rise/src/services/preferences_service.dart';
import 'package:go_router/go_router.dart';

class CodeChallengePage extends StatefulWidget {
  static const String routeName = '/challenge';

  const CodeChallengePage({super.key});

  @override
  State<CodeChallengePage> createState() => _CodeChallengePageState();
}

class _CodeChallengePageState extends State<CodeChallengePage> {
  String _selectedLanguage = 'python';
  late CodeController _codeController;

  // Language code templates/boilerplates
  final Map<String, String> _templates = {
    'python': '''class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        prevMap = {} # val : index
        for i, n in enumerate(nums):
            diff = target - n
            if diff in prevMap:
                return [prevMap[diff], i]
        return''',
    'cpp': '''#include <vector>
#include <unordered_map>

class Solution {
public:
    std::vector<int> twoSum(std::vector<int>& nums, int target) {
        std::unordered_map<int, int> prevMap;
        for (int i = 0; i < nums.size(); i++) {
            int diff = target - nums[i];
            if (prevMap.find(diff) != prevMap.end()) {
                return {prevMap[diff], i};
            }
            prevMap[nums[i]] = i;
        }
        return {};
    }
};''',
    'go': '''package main

func twoSum(nums []int, target int) []int {
    prevMap := make(map[int]int)
    for i, n := range nums {
        diff := target - n
        if idx, ok := prevMap[diff]; ok {
            return []int{idx, i}
        }
        prevMap[n] = i
    }
    return nil
}''',
    'rust': '''use std::collections::HashMap;

pub struct Solution;

impl Solution {
    pub fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        let mut prev_map = HashMap::new();
        for (i, &n) in nums.iter().enumerate() {
            let diff = target - n;
            if let Some(&idx) = prev_map.get(&diff) {
                return vec![idx as i32, i as i32];
            }
            prev_map.insert(n, i);
        }
        vec![]
    }
}''',
    'javascript': '''class Solution {
    twoSum(nums, target) {
        const prevMap = {}; // val : index
        for (let i = 0; i < nums.length; i++) {
            const n = nums[i];
            const diff = target - n;
            if (diff in prevMap) {
                return [prevMap[diff], i];
            }
            prevMap[n] = i;
        }
        return [];
    }
}''',
  };

  // Maps display names to GoRouter highlighting objects
  final Map<String, dynamic> _highlightLanguages = {
    'python': python,
    'cpp': cpp,
    'go': go,
    'rust': rust,
    'javascript': javascript,
  };

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: _templates[_selectedLanguage]!,
      language: _highlightLanguages[_selectedLanguage],
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onLanguageChanged(String? newLanguage) {
    if (newLanguage != null && newLanguage != _selectedLanguage) {
      setState(() {
        _selectedLanguage = newLanguage;
        _codeController = CodeController(
          text: _templates[newLanguage]!,
          language: _highlightLanguages[newLanguage],
        );
      });
    }
  }

  // Compiler syntax error check
  bool _hasSyntaxError(String code) {
    // Basic balanced brackets parsing
    List<String> stack = [];
    Map<String, String> matching = {')': '(', ']': '[', '}': '{'};

    for (int i = 0; i < code.length; i++) {
      String char = code[i];
      if (matching.values.contains(char)) {
        stack.add(char);
      } else if (matching.containsKey(char)) {
        if (stack.isEmpty || stack.last != matching[char]) {
          return true;
        }
        stack.removeLast();
      }
    }
    return stack.isNotEmpty;
  }

  // Solution logic verification
  bool _isLogicCorrect(String code, String language) {
    final lower = code.toLowerCase();
    if (language == 'python') {
      return lower.contains('target - n') ||
             lower.contains('target - num') ||
             lower.contains('target - x') ||
             lower.contains('diff');
    } else if (language == 'cpp') {
      return lower.contains('find') || lower.contains('count');
    } else if (language == 'go') {
      return lower.contains('prevmap') && lower.contains('range');
    } else if (language == 'rust') {
      return lower.contains('prev_map.get') || lower.contains('iter().enumerate()');
    } else if (language == 'javascript') {
      return lower.contains('prevmap') || lower.contains('target - n') || lower.contains('nums[i]');
    }
    return false;
  }

  // Evaluate compiler run & return list of test results
  List<TestCaseResult> _runTestCases(String code, String lang) {
    final isCorrect = _isLogicCorrect(code, lang);

    if (isCorrect) {
      return [
        TestCaseResult(
          input: 'nums = [2,7,11,15], target = 9',
          expected: '[0,1]',
          actual: '[0,1]',
          passed: true,
        ),
        TestCaseResult(
          input: 'nums = [3,2,4], target = 6',
          expected: '[1,2]',
          actual: '[1,2]',
          passed: true,
        ),
        TestCaseResult(
          input: 'nums = [3,3], target = 6',
          expected: '[0,1]',
          actual: '[0,1]',
          passed: true,
        ),
      ];
    } else {
      // Return wrong answer output
      return [
        TestCaseResult(
          input: 'nums = [2,7,11,15], target = 9',
          expected: '[0,1]',
          actual: '[]',
          passed: false,
        ),
        TestCaseResult(
          input: 'nums = [3,2,4], target = 6',
          expected: '[1,2]',
          actual: '[]',
          passed: false,
        ),
        TestCaseResult(
          input: 'nums = [3,3], target = 6',
          expected: '[0,1]',
          actual: '[]',
          passed: false,
        ),
      ];
    }
  }

  void _executeRun() {
    final code = _codeController.text;
    final syntaxError = _hasSyntaxError(code);
    final results = _runTestCases(code, _selectedLanguage);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TestCasesPanel(
          hasSyntaxError: syntaxError,
          syntaxErrorMessage: 'SyntaxError: unbalanced parentheses/brackets in Solution.py on line 6',
          results: results,
          runtime: '32 ms',
          memory: '14.2 MB',
        );
      },
    );
  }

  void _executeSubmit() {
    final code = _codeController.text;
    final syntaxError = _hasSyntaxError(code);
    final results = _runTestCases(code, _selectedLanguage);
    final bool passed = !syntaxError && results.every((r) => r.passed);

    // Show Judging Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primaryFixedDim),
                SizedBox(height: 16),
                Text(
                  'Judging...',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    color: AppColors.primary,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Simulated network delay
    Timer(const Duration(seconds: 1500 ~/ 1000), () async {
      Navigator.of(context).pop(); // Dismiss Judging Dialog

      if (passed) {
        // Increment solved challenges and XP persistently
        final prefs = PreferencesService.instance;
        await prefs.incrementSolvedCount();
        await prefs.addXp(15);

        if (mounted) {
          _showResultDialog(true);
        }
      } else {
        if (mounted) {
          _showResultDialog(false, message: syntaxError ? 'Compile Error' : 'Wrong Answer');
        }
      }
    });
  }

  void _showResultDialog(bool success, {String message = 'Wrong Answer'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white10),
          ),
          title: Text(
            success ? 'Accepted' : message,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: success ? AppColors.tertiaryFixedDim : AppColors.error,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (success) ...[
                const Text(
                  '🎉 All test cases passed successfully!',
                  style: TextStyle(color: AppColors.onSurface),
                ),
                const SizedBox(height: 12),
                Text(
                  'Runtime: 48 ms (beats 92.5% of Python3 submissions)',
                  style: AppText.labelCode.copyWith(fontSize: 12),
                ),
                Text(
                  'Memory: 16.1 MB (beats 88.4%)',
                  style: AppText.labelCode.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 12),
                Text(
                  'Rewards: +15 XP',
                  style: AppText.labelCode.copyWith(
                    color: AppColors.primaryFixedDim,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                Text(
                  '❌ Some test cases failed. Please review your code and try again.',
                  style: TextStyle(color: AppColors.onSurface),
                ),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss Dialog
                if (success) {
                  GoRouter.of(context).go('/main'); // Return back to Home
                }
              },
              child: Text(
                success ? 'RETURN HOME' : 'TRY AGAIN',
                style: AppText.labelCaps.copyWith(
                  color: AppColors.primaryFixedDim,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ChallengeTopBar(
        title: 'Two Sum',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Problem Description Panel (Collapsible)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ProblemPanel(
              difficulty: 'Medium',
              topics: 'Array, Hash Table',
              descriptionText:
                  'Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.',
              exampleInput: '[2,7,11,15], target = 9',
              exampleOutput: '[0,1]',
            ),
          ),
          const SizedBox(height: 12),

          // Code Toolbar with Language Selector Dropdown
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.surfaceContainerLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Code Editor'.toUpperCase(),
                  style: AppText.labelCaps.copyWith(
                    fontSize: 10,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1.0,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  dropdownColor: AppColors.surface,
                  underline: const SizedBox(),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primaryFixedDim,
                  ),
                  style: AppText.labelCode.copyWith(
                    color: AppColors.primaryFixedDim,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: _onLanguageChanged,
                  items: const [
                    DropdownMenuItem(value: 'python', child: Text('Python3')),
                    DropdownMenuItem(value: 'cpp', child: Text('C++')),
                    DropdownMenuItem(value: 'go', child: Text('Go')),
                    DropdownMenuItem(value: 'rust', child: Text('Rust')),
                    DropdownMenuItem(value: 'javascript', child: Text('JavaScript')),
                  ],
                ),
              ],
            ),
          ),

          // Code Editor Area wrapping CodeField
          Expanded(
            child: CodeEditorArea(
              controller: _codeController,
            ),
          ),

          // Shortcut Keys Helper Toolbar
          const EditorToolbar(),
        ],
      ),
      bottomNavigationBar: ChallengeActionBar(
        onRun: _executeRun,
        onSubmit: _executeSubmit,
      ),
    );
  }
}
