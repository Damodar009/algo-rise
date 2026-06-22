import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:algo_rise/src/config/themes/colors.dart';

class CodeEditorArea extends StatelessWidget {
  final CodeController controller;
  final FocusNode? focusNode;
  final TextStyle? textStyle;

  const CodeEditorArea({
    super.key,
    required this.controller,
    this.focusNode,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle =
        textStyle ??
        const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
          fontWeight: FontWeight.w300,
          height: 1.5,
        );

    return Container(
      color: const Color(0xFF282C34), // Match editor background color
      child: CodeTheme(
        data: CodeThemeData(styles: atomOneDarkTheme),
        child: CodeField(
          controller: controller,
          focusNode: focusNode,
          expands: true,
          maxLines: null,
          minLines: null,
          textStyle: defaultStyle,
          gutterStyle: GutterStyle(
            showLineNumbers: true,
            showErrors: true,
            showFoldingHandles: false,
            width: 60.0,
            margin: 8.0,
            textAlign: TextAlign.right,
            textStyle: TextStyle(
              fontFamily: 'JetBrainsMono',
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              fontSize: (defaultStyle.fontSize ?? 14) - 1,
            ),
            background: const Color(0xFF282C34),
          ),
        ),
      ),
    );
  }
}
