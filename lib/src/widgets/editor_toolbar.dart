import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/widgets/glass_card.dart';

class EditorToolbar extends StatelessWidget {
  final CodeController controller;
  final FocusNode? focusNode;

  const EditorToolbar({super.key, required this.controller, this.focusNode});

  @override
  Widget build(BuildContext context) {
    final List<(String, Color)> keys = [
      ('Tab', AppColors.onSurfaceVariant),
      ('{', AppColors.primaryFixedDim),
      ('}', AppColors.primaryFixedDim),
      ('(', AppColors.primaryFixedDim),
      (')', AppColors.primaryFixedDim),
      ('[', AppColors.primaryFixedDim),
      (']', AppColors.primaryFixedDim),
      (':', AppColors.primaryFixedDim),
      (';', AppColors.primaryFixedDim),
      ('=', AppColors.primaryFixedDim),
      ('!=', AppColors.primaryFixedDim),
      ('->', AppColors.primaryFixedDim),
    ];

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        border: const Border(top: BorderSide(color: Colors.white10, width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: keys.map((keyInfo) {
            final label = keyInfo.$1;
            final color = keyInfo.$2;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () => _handleKeyTap(label),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  child: Text(
                    label,
                    style: AppText.labelCode.copyWith(
                      fontSize: label == 'Tab' ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _handleKeyTap(String symbol) {
    final selection = controller.selection;
    final textToInsert = symbol == 'Tab' ? '    ' : symbol;
    final currentText = controller.text;

    if (selection.start < 0 || selection.end < 0) {
      final newText = currentText + textToInsert;
      controller.value = controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } else {
      final newText = currentText.replaceRange(
        selection.start,
        selection.end,
        textToInsert,
      );
      controller.value = controller.value.copyWith(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + textToInsert.length,
        ),
      );
    }
    focusNode?.requestFocus();
  }
}
