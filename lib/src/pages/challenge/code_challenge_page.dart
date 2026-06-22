import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/go.dart';
import 'package:highlight/languages/rust.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/typescript.dart';
import 'package:highlight/languages/cs.dart';
import 'package:highlight/languages/kotlin.dart';
import 'package:highlight/languages/swift.dart';
import 'package:highlight/languages/php.dart';
import 'package:highlight/languages/ruby.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/scala.dart';
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

// LeetCode & Code Execution additions
import 'package:dio/dio.dart';
import 'package:algo_rise/src/models/leetcode_problem.dart';
import 'package:algo_rise/src/services/code_execution_service.dart';
import 'package:algo_rise/src/widgets/problem_selector_dialog.dart';
import 'package:algo_rise/src/widgets/execution_settings_dialog.dart';

class CodeChallengePage extends StatefulWidget {
  static const String routeName = '/challenge';

  const CodeChallengePage({super.key});

  @override
  State<CodeChallengePage> createState() => _CodeChallengePageState();
}

class _CodeChallengePageState extends State<CodeChallengePage> {
  final CodeExecutionService _executionService = CodeExecutionService();
  final Dio _dio = Dio();
  LeetCodeProblemDetail? _problemDetail;
  bool _isProblemLoading = true;
  String _loadError = '';

  String _selectedLanguage = 'python';
  late CodeController _codeController;
  late FocusNode _focusNode;

  double _fontSize = 14.0;
  bool _isItalic = false;
  FontWeight _fontWeight = FontWeight.w300;

  TextStyle get _editorTextStyle => TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: _fontSize,
    fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
    fontWeight: _fontWeight,
    height: 1.5,
  );

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
    'java': '''import java.util.HashMap;
import java.util.Map;

class Solution {
    public int[] twoSum(int[] nums, int target) {
        Map<Integer, Integer> prevMap = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
            int num = nums[i];
            int diff = target - num;
            if (prevMap.containsKey(diff)) {
                return new int[] { prevMap.get(diff), i };
            }
            prevMap.put(num, i);
        }
        return new int[] {};
    }
}''',
    'typescript': '''function twoSum(nums: number[], target: number): number[] {
    const prevMap: { [key: number]: number } = {};
    for (let i = 0; i < nums.length; i++) {
        const diff = target - nums[i];
        if (diff in prevMap) {
            return [prevMap[diff], i];
        }
        prevMap[nums[i]] = i;
    }
    return [];
}''',
    'cs': '''using System.Collections.Generic;

public class Solution {
    public int[] TwoSum(int[] nums, int target) {
        Dictionary<int, int> prevMap = new Dictionary<int, int>();
        for (int i = 0; i < nums.Length; i++) {
            int diff = target - nums[i];
            if (prevMap.ContainsKey(diff)) {
                return new int[] { prevMap[diff], i };
            }
            prevMap[nums[i]] = i;
        }
        return new int[0];
    }
}''',
    'kotlin': '''class Solution {
    fun twoSum(nums: IntArray, target: Int): IntArray {
        val prevMap = HashMap<Int, Int>()
        for (i in nums.indices) {
            val diff = target - nums[i]
            if (prevMap.containsKey(diff)) {
                return intArrayOf(prevMap[diff]!!, i)
            }
            prevMap[nums[i]] = i
        }
        return intArrayOf()
    }
}''',
    'swift': '''class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var prevMap = [Int: Int]()
        for (i, num) in nums.enumerated() {
            let diff = target - num
            if let index = prevMap[diff] {
                return [index, i]
            }
            prevMap[num] = i
        }
        return []
    }
}''',
    'php': '''class Solution {
    function twoSum(\$nums, \$target) {
        \$prevMap = [];
        foreach (\$nums as \$i => \$n) {
            \$diff = \$target - \$n;
            if (array_key_exists(\$diff, \$prevMap)) {
                return [\$prevMap[\$diff], \$i];
            }
            \$prevMap[\$n] = \$i;
        }
        return [];
    }
}''',
    'ruby': '''def two_sum(nums, target)
  prev_map = {}
  nums.each_with_index do |n, i|
    diff = target - n
    if prev_map.key?(diff)
      return [prev_map[diff], i]
    end
    prev_map[n] = i
  end
  []
end''',
    'dart': '''class Solution {
  List<int> twoSum(List<int> nums, int target) {
    final prevMap = <int, int>{};
    for (var i = 0; i < nums.length; i++) {
      final diff = target - nums[i];
      if (prevMap.containsKey(diff)) {
        return [prevMap[diff]!, i];
      }
      prevMap[nums[i]] = i;
    }
    return [];
  }
}''',
    'scala': '''import scala.collection.mutable

object Solution {
    def twoSum(nums: Array[Int], target: Int): Array[Int] = {
        val prevMap = mutable.Map[Int, Int]()
        for (i <- nums.indices) {
            val diff = target - nums[i]
            if (prevMap.contains(diff)) {
                return Array(prevMap(diff), i)
            }
            prevMap(nums[i]) = i
        }
        Array()
    }
}''',
    'c': '''#include <stdlib.h>

int* twoSum(int* nums, int numsSize, int target, int* returnSize) {
    *returnSize = 2;
    int* result = (int*)malloc(2 * sizeof(int));
    for (int i = 0; i < numsSize; i++) {
        for (int j = i + 1; j < numsSize; j++) {
            if (nums[i] + nums[j] == target) {
                result[0] = i;
                result[1] = j;
                return result;
            }
        }
    }
    *returnSize = 0;
    return NULL;
}''',
  };

  // Maps display names to GoRouter highlighting objects
  final Map<String, dynamic> _highlightLanguages = {
    'python': python,
    'cpp': cpp,
    'go': go,
    'rust': rust,
    'javascript': javascript,
    'java': java,
    'typescript': typescript,
    'cs': cs,
    'kotlin': kotlin,
    'swift': swift,
    'php': php,
    'ruby': ruby,
    'dart': dart,
    'scala': scala,
    'c': cpp,
  };

  LeetCodeProblemDetail _getDummyProblemDetail() {
    return LeetCodeProblemDetail(
      problem: LeetCodeProblem(
        titleSlug: 'two-sum',
        title: 'Two Sum (Offline Fallback)',
        frontendId: '1',
        difficulty: 'Easy',
        tags: ['Array', 'Hash Table'],
      ),
      htmlDescription: '''
        <p>Given an array of integers <code>nums</code> and an integer <code>target</code>, return <i>indices of the two numbers such that they add up to <code>target</code></i>.</p>
        <p>You may assume that each input would have <b><i>exactly</i> one solution</b>, and you may not use the <i>same</i> element twice.</p>
        <p>You can return the answer in any order.</p>
        <pre>
<strong>Input:</strong> nums = [2,7,11,15], target = 9
<strong>Output:</strong> [0,1]
<strong>Explanation:</strong> Because nums[0] + nums[1] == 9, we return [0, 1].
        </pre>
      ''',
      exampleTestcases: '[2,7,11,15]\n9',
      parsedExamples: [
        LeetCodeExample(
          input: 'nums = [2,7,11,15], target = 9',
          output: '[0,1]',
          explanation: 'Because nums[0] + nums[1] == 9, we return [0, 1].',
        ),
      ],
    );
  }

  Future<void> _loadProblemDetail(String titleSlug) async {
    try {
      setState(() {
        _isProblemLoading = true;
        _loadError = '';
      });

      final response = await _dio.get(
        'https://alfa-leetcode-api.onrender.com/select?titleSlug=$titleSlug',
      );
      if (response.statusCode == 200) {
        setState(() {
          _problemDetail = LeetCodeProblemDetail.fromJson(response.data);
          _isProblemLoading = false;
        });
      } else {
        setState(() {
          _problemDetail = _getDummyProblemDetail();
          _isProblemLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _problemDetail = _getDummyProblemDetail();
        _isProblemLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _codeController = CodeController(
      text: _templates[_selectedLanguage]!,
      language: _highlightLanguages[_selectedLanguage],
      analyzer: DefaultLocalAnalyzer(),
    );
    _loadProblemDetail('two-sum');
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onLanguageChanged(String? newLanguage) {
    if (newLanguage != null && newLanguage != _selectedLanguage) {
      setState(() {
        _selectedLanguage = newLanguage;
        _codeController.dispose();
        _codeController = CodeController(
          text: _templates[newLanguage]!,
          language: _highlightLanguages[newLanguage],
          analyzer: DefaultLocalAnalyzer(),
        );
      });
    }
  }

  void _showProblemSelector() async {
    final LeetCodeProblem? selected = await showDialog<LeetCodeProblem>(
      context: context,
      builder: (context) => const ProblemSelectorDialog(),
    );
    if (selected != null) {
      _loadProblemDetail(selected.titleSlug);
    }
  }

  void _showExecutionSettings() async {
    await showDialog(
      context: context,
      builder: (context) => const ExecutionSettingsDialog(),
    );
    setState(() {}); // trigger rebuild to update preferences
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

  void _executeRun() async {
    final code = _codeController.text;

    final syntaxError = _hasSyntaxError(code);
    if (syntaxError) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return TestCasesPanel(
            hasSyntaxError: true,
            syntaxErrorMessage:
                'SyntaxError: unbalanced parentheses/brackets in code.',
            results: const [],
            runtime: '0 ms',
            memory: '0 MB',
          );
        },
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryFixedDim),
      ),
    );

    try {
      final examples = _problemDetail?.parsedExamples ?? [];
      final List<TestCaseResult> results = [];
      String? compileError;
      String runtime = 'N/A';
      String memory = 'N/A';

      if (examples.isEmpty) {
        final res = await _executionService.runCode(
          code: code,
          language: _selectedLanguage,
          input: _problemDetail?.exampleInput ?? '[2,7,11,15], target = 9',
          expectedOutput: _problemDetail?.exampleOutput ?? '[0,1]',
        );
        compileError = res.compileError;
        if (res.time != null) runtime = res.time!;
        if (res.memory != null) memory = res.memory!;

        results.add(
          TestCaseResult(
            input: _problemDetail?.exampleInput ?? '[2,7,11,15], target = 9',
            expected: _problemDetail?.exampleOutput ?? '[0,1]',
            actual: res.stdout.isNotEmpty
                ? res.stdout
                : (res.stderr.isNotEmpty ? res.stderr : '[]'),
            passed: res.success,
          ),
        );
      } else {
        for (final ex in examples) {
          final res = await _executionService.runCode(
            code: code,
            language: _selectedLanguage,
            input: ex.input,
            expectedOutput: ex.output,
          );

          if (res.compileError != null) {
            compileError = res.compileError;
            break;
          }
          if (res.time != null) runtime = res.time!;
          if (res.memory != null) memory = res.memory!;

          results.add(
            TestCaseResult(
              input: ex.input,
              expected: ex.output,
              actual: res.stdout.isNotEmpty
                  ? res.stdout
                  : (res.stderr.isNotEmpty ? res.stderr : '[]'),
              passed: res.success,
            ),
          );
        }
      }

      if (mounted) Navigator.of(context).pop(); // Dismiss Loading

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return TestCasesPanel(
              hasSyntaxError: compileError != null,
              syntaxErrorMessage: compileError ?? '',
              results: results,
              runtime: runtime,
              memory: memory,
            );
          },
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop(); // Dismiss Loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Run failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _executeSubmit() async {
    final code = _codeController.text;

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

    try {
      final examples = _problemDetail?.parsedExamples ?? [];
      bool allPassed = true;
      String? errorMessage;

      if (examples.isEmpty) {
        final res = await _executionService.runCode(
          code: code,
          language: _selectedLanguage,
          input: _problemDetail?.exampleInput ?? '[2,7,11,15], target = 9',
          expectedOutput: _problemDetail?.exampleOutput ?? '[0,1]',
        );
        allPassed = res.success;
        if (res.compileError != null) {
          errorMessage = 'Compile Error';
        } else if (!res.success) {
          errorMessage = 'Wrong Answer';
        }
      } else {
        for (final ex in examples) {
          final res = await _executionService.runCode(
            code: code,
            language: _selectedLanguage,
            input: ex.input,
            expectedOutput: ex.output,
          );
          if (res.compileError != null) {
            allPassed = false;
            errorMessage = 'Compile Error';
            break;
          }
          if (!res.success) {
            allPassed = false;
            errorMessage = 'Wrong Answer';
            break;
          }
        }
      }

      if (mounted) Navigator.of(context).pop(); // Dismiss Dialog

      if (allPassed) {
        final prefs = PreferencesService.instance;
        await prefs.incrementSolvedCount();
        await prefs.addXp(15);
        if (mounted) {
          _showResultDialog(true);
        }
      } else {
        if (mounted) {
          _showResultDialog(false, message: errorMessage ?? 'Wrong Answer');
        }
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop(); // Dismiss Dialog
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Submit failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
              ],
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
    if (_isProblemLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: ChallengeTopBar(title: 'Loading Problem...'),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryFixedDim),
        ),
      );
    }

    if (_loadError.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const ChallengeTopBar(title: 'Error Loading'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _loadError,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryFixedDim,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => _loadProblemDetail('two-sum'),
                child: const Text('Load Default (Two Sum)'),
              ),
            ],
          ),
        ),
      );
    }

    final detail = _problemDetail!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: ChallengeTopBar(
          title: detail.problem.title,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.list_alt,
                color: AppColors.primaryFixedDim,
              ),
              onPressed: _showProblemSelector,
              tooltip: 'Select LeetCode Problem',
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: AppColors.primaryFixedDim,
              ),
              onPressed: _showExecutionSettings,
              tooltip: 'Execution Settings',
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: Colors.white10, width: 1),
                ),
              ),
              child: const TabBar(
                dividerColor: Colors.transparent,
                indicatorColor: AppColors.primaryFixedDim,
                indicatorWeight: 3,
                labelColor: AppColors.primaryFixedDim,
                unselectedLabelColor: AppColors.onSurfaceVariant,
                tabs: [
                  Tab(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description_outlined, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Question',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.code, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Code Editor',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: Question
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ProblemPanel(
                      difficulty: detail.problem.difficulty,
                      topics: detail.problem.tags.join(' • '),
                      descriptionText: detail.htmlDescription,
                      exampleInput: detail.parsedExamples.isNotEmpty
                          ? detail.parsedExamples[0].input
                          : '',
                      exampleOutput: detail.parsedExamples.isNotEmpty
                          ? detail.parsedExamples[0].output
                          : '',
                      parsedExamples: detail.parsedExamples,
                    ),
                  ),
                  // Tab 2: Code Editor
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16),
                                  color: AppColors.onSurfaceVariant,
                                  onPressed: () {
                                    setState(() {
                                      if (_fontSize > 10) _fontSize -= 1;
                                    });
                                  },
                                  tooltip: 'Decrease Font Size',
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                Text(
                                  '${_fontSize.toInt()}',
                                  style: const TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 12,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16),
                                  color: AppColors.onSurfaceVariant,
                                  onPressed: () {
                                    setState(() {
                                      if (_fontSize < 24) _fontSize += 1;
                                    });
                                  },
                                  tooltip: 'Increase Font Size',
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    _isItalic
                                        ? Icons.format_italic
                                        : Icons.format_italic_outlined,
                                    size: 18,
                                  ),
                                  color: _isItalic
                                      ? AppColors.primaryFixedDim
                                      : AppColors.onSurfaceVariant,
                                  onPressed: () {
                                    setState(() {
                                      _isItalic = !_isItalic;
                                    });
                                  },
                                  tooltip: 'Toggle Italic',
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: Icon(
                                    _fontWeight == FontWeight.w700
                                        ? Icons.format_bold
                                        : (_fontWeight == FontWeight.w400
                                              ? Icons.format_bold_outlined
                                              : Icons.text_fields),
                                    size: 18,
                                  ),
                                  color:
                                      _fontWeight == FontWeight.w700 ||
                                          _fontWeight == FontWeight.w400
                                      ? AppColors.primaryFixedDim
                                      : AppColors.onSurfaceVariant,
                                  onPressed: () {
                                    setState(() {
                                      if (_fontWeight == FontWeight.w300) {
                                        _fontWeight = FontWeight.w400;
                                      } else if (_fontWeight ==
                                          FontWeight.w400) {
                                        _fontWeight = FontWeight.w700;
                                      } else {
                                        _fontWeight = FontWeight.w300;
                                      }
                                    });
                                  },
                                  tooltip: _fontWeight == FontWeight.w300
                                      ? 'Font: Light (Slim)'
                                      : (_fontWeight == FontWeight.w400
                                            ? 'Font: Regular'
                                            : 'Font: Bold'),
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                              ],
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
                                DropdownMenuItem(
                                  value: 'python',
                                  child: Text('Python3'),
                                ),
                                DropdownMenuItem(
                                  value: 'cpp',
                                  child: Text('C++'),
                                ),
                                DropdownMenuItem(
                                  value: 'go',
                                  child: Text('Go'),
                                ),
                                DropdownMenuItem(
                                  value: 'rust',
                                  child: Text('Rust'),
                                ),
                                DropdownMenuItem(
                                  value: 'javascript',
                                  child: Text('JavaScript'),
                                ),
                                DropdownMenuItem(
                                  value: 'java',
                                  child: Text('Java'),
                                ),
                                DropdownMenuItem(
                                  value: 'typescript',
                                  child: Text('TypeScript'),
                                ),
                                DropdownMenuItem(
                                  value: 'cs',
                                  child: Text('C#'),
                                ),
                                DropdownMenuItem(
                                  value: 'kotlin',
                                  child: Text('Kotlin'),
                                ),
                                DropdownMenuItem(
                                  value: 'swift',
                                  child: Text('Swift'),
                                ),
                                DropdownMenuItem(
                                  value: 'php',
                                  child: Text('PHP'),
                                ),
                                DropdownMenuItem(
                                  value: 'ruby',
                                  child: Text('Ruby'),
                                ),
                                DropdownMenuItem(
                                  value: 'dart',
                                  child: Text('Dart'),
                                ),
                                DropdownMenuItem(
                                  value: 'scala',
                                  child: Text('Scala'),
                                ),
                                DropdownMenuItem(value: 'c', child: Text('C')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Code Editor Area wrapping CodeField
                      Expanded(
                        child: CodeEditorArea(
                          controller: _codeController,
                          focusNode: _focusNode,
                          textStyle:
                              _editorTextStyle, // Custom VS Code-like text style
                        ),
                      ),
                      // Shortcut Keys Helper Toolbar
                      EditorToolbar(
                        controller: _codeController,
                        focusNode: _focusNode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: ChallengeActionBar(
          onRun: _executeRun,
          onSubmit: _executeSubmit,
        ),
      ),
    );
  }
}
