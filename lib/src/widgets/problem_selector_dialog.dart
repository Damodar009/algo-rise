import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:algo_rise/src/models/leetcode_problem.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';

class ProblemSelectorDialog extends StatefulWidget {
  const ProblemSelectorDialog({super.key});

  @override
  State<ProblemSelectorDialog> createState() => _ProblemSelectorDialogState();
}

class _ProblemSelectorDialogState extends State<ProblemSelectorDialog> {
  final Dio _dio = Dio();
  List<LeetCodeProblem> _problems = [];
  List<LeetCodeProblem> _filteredProblems = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchProblems();
  }

  Future<void> _fetchProblems() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final response = await _dio.get('https://alfa-leetcode-api.onrender.com/problems?limit=100');
      if (response.statusCode == 200) {
        final data = response.data;
        final List rawList = data['problemsetQuestionList'] ?? [];
        final list = rawList.map((e) => LeetCodeProblem.fromJson(e)).toList();
        
        setState(() {
          _problems = list;
          _filteredProblems = list;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load problems: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching problems. Are you online?';
        _isLoading = false;
      });
    }
  }

  void _filterProblems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProblems = _problems;
      } else {
        final lower = query.toLowerCase();
        _filteredProblems = _problems.where((p) {
          return p.title.toLowerCase().contains(lower) ||
              p.frontendId.contains(lower) ||
              p.tags.any((t) => t.toLowerCase().contains(lower));
        }).toList();
      }
    });
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF00B8A3);
      case 'medium':
        return const Color(0xFFFFC01E);
      case 'hard':
        return const Color(0xFFFF375F);
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1117), // Match editor background color
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select LeetCode Problem',
                    style: AppText.headlineMd.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white60),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: TextField(
                onChanged: _filterProblems,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by title, ID, or tag...',
                  hintStyle: const TextStyle(color: Colors.white30),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryFixedDim, width: 1),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),

            // Content Area
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: AppColors.primaryFixedDim),
                        ),
                      )
                    : _error.isNotEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_error, style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryFixedDim,
                                      foregroundColor: Colors.black,
                                    ),
                                    onPressed: _fetchProblems,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : _filteredProblems.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40),
                                  child: Text('No problems found.', style: TextStyle(color: Colors.white38)),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                itemCount: _filteredProblems.length,
                                itemBuilder: (context, index) {
                                  final p = _filteredProblems[index];
                                  final diffColor = _getDifficultyColor(p.difficulty);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(8),
                                      onTap: () => Navigator.of(context).pop(p),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            // Frontend ID
                                            SizedBox(
                                              width: 44,
                                              child: Text(
                                                p.frontendId,
                                                style: TextStyle(
                                                  fontFamily: 'JetBrainsMono',
                                                  color: Colors.white.withValues(alpha: 0.35),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            // Title & Tags
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    p.title,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  if (p.tags.isNotEmpty) ...[
                                                    const SizedBox(height: 4),
                                                    Wrap(
                                                      spacing: 4,
                                                      children: p.tags.take(3).map((tag) {
                                                        return Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white.withValues(alpha: 0.05),
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child: Text(
                                                            tag,
                                                            style: const TextStyle(
                                                              color: Colors.white38,
                                                              fontSize: 9,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Difficulty Badge
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: diffColor.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(color: diffColor.withValues(alpha: 0.2)),
                                              ),
                                              child: Text(
                                                p.difficulty,
                                                style: TextStyle(
                                                  fontFamily: 'JetBrainsMono',
                                                  color: diffColor,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
