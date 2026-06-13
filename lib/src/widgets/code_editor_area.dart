import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:algo_rise/src/config/themes/colors.dart';

class CodeEditorArea extends StatelessWidget {
  final CodeController controller;

  const CodeEditorArea({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1117), // Match editor background color
      child: CodeTheme(
        data: CodeThemeData(styles: draculaTheme),
        child: CodeField(
          controller: controller,
          textStyle: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 15,
            height: 1.5,
          ),
          gutterStyle: GutterStyle(
            showLineNumbers: true,
            showErrors: false,
            showFoldingHandles: false,
            width: 44.0,
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              fontFamily: 'JetBrainsMono',
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              fontSize: 14,
            ),
            background: const Color(0xFF0D1117),
          ),
        ),
      ),
    );
  }
}
