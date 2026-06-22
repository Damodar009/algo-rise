import 'package:dio/dio.dart';
import 'package:algo_rise/src/services/preferences_service.dart';

class ExecutionResult {
  final bool success;
  final String stdout;
  final String stderr;
  final String? compileError;
  final String? time;
  final String? memory;

  ExecutionResult({
    required this.success,
    required this.stdout,
    required this.stderr,
    this.compileError,
    this.time,
    this.memory,
  });
}

class CodeExecutionService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));

  // Map language identifiers to Piston languages
  static const Map<String, String> _pistonLangs = {
    'python': 'python',
    'cpp': 'cpp',
    'go': 'go',
    'rust': 'rust',
    'javascript': 'javascript',
    'java': 'java',
    'typescript': 'typescript',
    'cs': 'csharp',
    'kotlin': 'kotlin',
    'swift': 'swift',
    'php': 'php',
    'ruby': 'ruby',
    'dart': 'dart',
    'scala': 'scala',
    'c': 'c',
  };

  // Map language identifiers to Judge0 IDs
  static const Map<String, int> _judge0Langs = {
    'python': 92, // Python 3.11.2
    'cpp': 76,    // C++ GCC 13
    'go': 95,     // Go 1.20
    'rust': 73,   // Rust 1.40
    'javascript': 93, // Node 18
    'java': 91,   // Java 17
    'typescript': 94, // TS 5.0
    'cs': 82,     // C# .NET
    'kotlin': 78, // Kotlin 1.3
    'swift': 83,  // Swift 5.3
    'php': 98,    // PHP 8.2
    'ruby': 72,   // Ruby 2.7
    'dart': 90,   // Dart 2.19
    'scala': 81,  // Scala 2.13
    'c': 75,      // C Clang 10
  };

  /// Run user code against input using selected backend
  Future<ExecutionResult> runCode({
    required String code,
    required String language,
    required String input,
    required String expectedOutput,
  }) async {
    final prefs = PreferencesService.instance;
    final backend = prefs.executionBackend;

    if (backend == 'piston') {
      return _runPiston(code, language, input, expectedOutput);
    } else if (backend == 'judge0') {
      return _runJudge0(code, language, input, expectedOutput);
    } else {
      return _runMock(code, language, input, expectedOutput);
    }
  }

  /// Piston execution backend
  Future<ExecutionResult> _runPiston(
    String code,
    String language,
    String input,
    String expectedOutput,
  ) async {
    final prefs = PreferencesService.instance;
    String host = prefs.pistonUrl.trim();
    if (host.isEmpty) {
      host = 'https://emkc.org'; // fallback
    }
    if (host.endsWith('/')) {
      host = host.substring(0, host.length - 1);
    }

    final pistonLang = _pistonLangs[language] ?? language;

    try {
      final response = await _dio.post(
        '$host/api/v2/piston/execute',
        data: {
          'language': pistonLang,
          'version': '*',
          'files': [
            {
              'name': _getFileName(language),
              'content': code,
            }
          ],
          'stdin': input,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        // Check for compilation errors
        if (data['compile'] != null && data['compile']['code'] != 0) {
          return ExecutionResult(
            success: false,
            stdout: '',
            stderr: '',
            compileError: data['compile']['stderr'] ?? data['compile']['output'] ?? 'Compilation Failed',
          );
        }

        final run = data['run'] ?? {};
        final stdout = (run['stdout'] ?? '').toString().trim();
        final stderr = (run['stderr'] ?? '').toString().trim();
        final exitCode = run['code'] ?? 0;

        final bool isSuccess = exitCode == 0 && stderr.isEmpty && _matchOutput(stdout, expectedOutput);

        return ExecutionResult(
          success: isSuccess,
          stdout: stdout,
          stderr: stderr,
        );
      } else {
        return ExecutionResult(
          success: false,
          stdout: '',
          stderr: 'Piston server returned status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ExecutionResult(
        success: false,
        stdout: '',
        stderr: 'Piston Error: $e',
      );
    }
  }

  /// Judge0 CE RapidAPI execution backend
  Future<ExecutionResult> _runJudge0(
    String code,
    String language,
    String input,
    String expectedOutput,
  ) async {
    final prefs = PreferencesService.instance;
    final key = prefs.rapidApiKey.trim();
    if (key.isEmpty) {
      return ExecutionResult(
        success: false,
        stdout: '',
        stderr: 'Error: RapidAPI Key is not configured. Please set it in Settings.',
      );
    }

    final langId = _judge0Langs[language] ?? 92;

    try {
      final response = await _dio.post(
        'https://judge0-extra-ce.p.rapidapi.com/submissions?wait=true&base64_encoded=false',
        options: Options(
          headers: {
            'X-RapidAPI-Key': key,
            'X-RapidAPI-Host': 'judge0-extra-ce.p.rapidapi.com',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'source_code': code,
          'language_id': langId,
          'stdin': input,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        final stdout = (data['stdout'] ?? '').toString().trim();
        final stderr = (data['stderr'] ?? '').toString().trim();
        final compileOutput = (data['compile_output'] ?? '').toString().trim();
        final status = data['status'] ?? {};
        final statusId = status['id'] ?? 3;
        final time = data['time']?.toString() ?? '0.00';
        final memory = data['memory']?.toString() ?? '0';

        if (statusId == 6 || compileOutput.isNotEmpty) {
          return ExecutionResult(
            success: false,
            stdout: '',
            stderr: '',
            compileError: compileOutput.isNotEmpty ? compileOutput : 'Compilation Error',
          );
        }

        final bool isSuccess = statusId == 3 && stderr.isEmpty && _matchOutput(stdout, expectedOutput);

        return ExecutionResult(
          success: isSuccess,
          stdout: stdout,
          stderr: stderr,
          time: '$time s',
          memory: '${(double.tryParse(memory) ?? 0) / 1024} MB',
        );
      } else {
        return ExecutionResult(
          success: false,
          stdout: '',
          stderr: 'Judge0 server returned status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ExecutionResult(
        success: false,
        stdout: '',
        stderr: 'Judge0 Error: $e',
      );
    }
  }

  /// Mock execution backend (uses regex patterns)
  Future<ExecutionResult> _runMock(
    String code,
    String language,
    String input,
    String expectedOutput,
  ) async {
    // Simulate networking delay
    await Future.delayed(const Duration(milliseconds: 600));

    final isCorrect = _isLogicCorrect(code, language);

    if (isCorrect) {
      return ExecutionResult(
        success: true,
        stdout: expectedOutput,
        stderr: '',
      );
    } else {
      return ExecutionResult(
        success: false,
        stdout: '[]',
        stderr: 'Wrong Answer',
      );
    }
  }

  bool _matchOutput(String actual, String expected) {
    final cleanActual = actual.replaceAll(RegExp(r'\s+'), '');
    final cleanExpected = expected.replaceAll(RegExp(r'\s+'), '');
    return cleanActual == cleanExpected;
  }

  String _getFileName(String language) {
    switch (language) {
      case 'python':
        return 'main.py';
      case 'cpp':
      case 'c':
        return 'main.cpp';
      case 'go':
        return 'main.go';
      case 'rust':
        return 'main.rs';
      case 'javascript':
        return 'main.js';
      case 'typescript':
        return 'main.ts';
      case 'java':
        return 'Main.java';
      case 'cs':
        return 'Main.cs';
      case 'kotlin':
        return 'Main.kt';
      case 'swift':
        return 'main.swift';
      case 'php':
        return 'main.php';
      case 'ruby':
        return 'main.rb';
      case 'dart':
        return 'main.dart';
      case 'scala':
        return 'Main.scala';
      default:
        return 'main';
    }
  }

  bool _isLogicCorrect(String code, String language) {
    final lower = code.toLowerCase();
    if (language == 'python') {
      return lower.contains('prevmap') ||
          lower.contains('target - n') ||
          lower.contains('target - num');
    } else if (language == 'cpp') {
      return lower.contains('prevmap') ||
          lower.contains('target - nums[i]') ||
          lower.contains('unordered_map');
    } else if (language == 'go') {
      return lower.contains('prevmap') || lower.contains('target - n');
    } else if (language == 'rust') {
      return lower.contains('prev_map') ||
          lower.contains('insert') ||
          lower.contains('target - n');
    } else if (language == 'javascript') {
      return lower.contains('prevmap') ||
          lower.contains('target - n') ||
          lower.contains('nums[i]');
    } else if (language == 'java') {
      return lower.contains('containskey') || lower.contains('target - num');
    } else if (language == 'typescript') {
      return lower.contains('in prevmap') || lower.contains('target - nums[i]');
    } else if (language == 'cs') {
      return lower.contains('containskey') ||
          lower.contains('target - nums[i]');
    } else if (language == 'kotlin') {
      return lower.contains('containskey') ||
          lower.contains('target - nums[i]');
    } else if (language == 'swift') {
      return lower.contains('prevmap[diff]') || lower.contains('enumerated()');
    } else if (language == 'php') {
      return lower.contains('array_key_exists') ||
          lower.contains('target - \$n');
    } else if (language == 'ruby') {
      return lower.contains('key?') || lower.contains('target - n');
    } else if (language == 'dart') {
      return lower.contains('containskey') ||
          lower.contains('target - nums[i]');
    } else if (language == 'scala') {
      return lower.contains('contains') || lower.contains('target - nums[i]');
    } else if (language == 'c') {
      return lower.contains('nums[i] + nums[j]') || lower.contains('target');
    }
    return false;
  }
}
