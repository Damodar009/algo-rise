import 'package:flutter/material.dart';
import 'package:algo_rise/src/config/themes/colors.dart';
import 'package:algo_rise/src/config/themes/app_text.dart';

class HtmlText extends StatelessWidget {
  final String html;

  const HtmlText({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    if (html.isEmpty) return const SizedBox.shrink();

    final widgets = parseHtmlToWidgets(html, context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  List<Widget> parseHtmlToWidgets(String rawHtml, BuildContext context) {
    final List<Widget> widgets = [];
    
    // Decodes common HTML entities
    String cleanHtml = rawHtml
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    // Regular expression to match <pre>...</pre> blocks
    final preRegex = RegExp(r'<pre>(.*?)</pre>', dotAll: true);
    
    int lastIndex = 0;
    for (final match in preRegex.allMatches(cleanHtml)) {
      // Process paragraphs before the preformatted block
      final textBefore = cleanHtml.substring(lastIndex, match.start);
      if (textBefore.trim().isNotEmpty) {
        widgets.addAll(_parseParagraphs(textBefore, context));
      }
      
      // Render code block inside pre tags
      final preContent = match.group(1) ?? '';
      // Strip tag tags from within code block
      final cleanPre = preContent.replaceAll(RegExp(r'<[^>]*>'), '').trim();
      
      widgets.add(
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Text(
            cleanPre,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12.5,
              height: 1.5,
              color: Colors.white70,
            ),
          ),
        ),
      );
      
      lastIndex = match.end;
    }
    
    // Process remainder of HTML text
    if (lastIndex < cleanHtml.length) {
      final textAfter = cleanHtml.substring(lastIndex);
      if (textAfter.trim().isNotEmpty) {
        widgets.addAll(_parseParagraphs(textAfter, context));
      }
    }
    
    return widgets;
  }

  List<Widget> _parseParagraphs(String text, BuildContext context) {
    final List<Widget> paragraphs = [];
    
    // Split text based on paragraph tags
    final List<String> pRuns = text.split(RegExp(r'</?p>'));
    
    for (final run in pRuns) {
      final cleanRun = run.trim();
      if (cleanRun.isEmpty) continue;
      
      // Render unordered lists
      if (cleanRun.contains('<li>')) {
        final List<String> liRuns = cleanRun.split(RegExp(r'</?li>'));
        for (final li in liRuns) {
          final cleanLi = li.trim();
          if (cleanLi.isEmpty || cleanLi == '<ul>' || cleanLi == '</ul>') continue;
          
          paragraphs.add(
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 4, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: AppColors.primaryFixedDim, fontSize: 14)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppText.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                        children: _parseInlineTags(cleanLi, context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      } else {
        // Render simple paragraphs
        paragraphs.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: RichText(
              text: TextSpan(
                style: AppText.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
                children: _parseInlineTags(cleanRun, context),
              ),
            ),
          ),
        );
      }
    }
    
    return paragraphs;
  }

  List<TextSpan> _parseInlineTags(String text, BuildContext context) {
    final List<TextSpan> spans = [];
    
    // Matches <code>, <strong>, <em>, and <a>
    final tagRegex = RegExp(
        r'(<code>.*?</code>|<strong>.*?</strong>|<em>.*?</em>|<a\s+[^>]*>.*?</a>)',
        dotAll: true);
    
    int lastIndex = 0;
    for (final match in tagRegex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      
      final matchedText = match.group(0) ?? '';
      if (matchedText.startsWith('<code>')) {
        final codeContent = matchedText.substring(6, matchedText.length - 7);
        spans.add(TextSpan(
          text: codeContent,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            color: AppColors.primaryFixedDim,
            backgroundColor: Colors.white10,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ));
      } else if (matchedText.startsWith('<strong>')) {
        final strongContent = matchedText.substring(8, matchedText.length - 9);
        spans.add(TextSpan(
          text: strongContent,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ));
      } else if (matchedText.startsWith('<em>')) {
        final emContent = matchedText.substring(4, matchedText.length - 5);
        spans.add(TextSpan(
          text: emContent,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ));
      } else if (matchedText.startsWith('<a')) {
        final textRegex = RegExp(r'>([^<]*)</a>');
        final linkText = textRegex.firstMatch(matchedText)?.group(1) ?? 'Link';
        spans.add(TextSpan(
          text: linkText,
          style: const TextStyle(
            color: AppColors.primaryFixedDim,
            decoration: TextDecoration.underline,
          ),
        ));
      }
      
      lastIndex = match.end;
    }
    
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }
    
    return spans;
  }
}
