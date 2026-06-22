class LeetCodeProblem {
  final String titleSlug;
  final String title;
  final String frontendId;
  final String difficulty;
  final List<String> tags;

  LeetCodeProblem({
    required this.titleSlug,
    required this.title,
    required this.frontendId,
    required this.difficulty,
    required this.tags,
  });

  factory LeetCodeProblem.fromJson(Map<String, dynamic> json) {
    final List<String> parsedTags = [];
    if (json['topicTags'] != null) {
      for (final tag in json['topicTags']) {
        if (tag['name'] != null) {
          parsedTags.add(tag['name'] as String);
        }
      }
    }
    return LeetCodeProblem(
      titleSlug: json['titleSlug'] ?? '',
      title: json['title'] ?? '',
      frontendId: (json['questionFrontendId'] ?? '').toString(),
      difficulty: json['difficulty'] ?? 'Easy',
      tags: parsedTags,
    );
  }
}

class LeetCodeExample {
  final String input;
  final String output;
  final String? explanation;

  LeetCodeExample({
    required this.input,
    required this.output,
    this.explanation,
  });
}

class LeetCodeProblemDetail {
  final LeetCodeProblem problem;
  final String htmlDescription;
  final String exampleTestcases;
  final List<LeetCodeExample> parsedExamples;

  String get exampleInput => parsedExamples.isNotEmpty ? parsedExamples[0].input : '';
  String get exampleOutput => parsedExamples.isNotEmpty ? parsedExamples[0].output : '';

  LeetCodeProblemDetail({
    required this.problem,
    required this.htmlDescription,
    required this.exampleTestcases,
    required this.parsedExamples,
  });

  factory LeetCodeProblemDetail.fromJson(Map<String, dynamic> json) {
    final problem = LeetCodeProblem.fromJson(json);
    final String htmlDescription = json['question'] ?? '';
    final String exampleTestcases = json['exampleTestcases'] ?? '';
    final List<LeetCodeExample> parsed = parseExamplesFromHtml(htmlDescription);
    
    return LeetCodeProblemDetail(
      problem: problem,
      htmlDescription: htmlDescription,
      exampleTestcases: exampleTestcases,
      parsedExamples: parsed,
    );
  }
}

List<LeetCodeExample> parseExamplesFromHtml(String html) {
  final List<LeetCodeExample> list = [];
  
  // Find all <pre>...</pre> blocks
  final preRegex = RegExp(r'<pre>(.*?)</pre>', dotAll: true);
  final matches = preRegex.allMatches(html);
  
  for (final match in matches) {
    final preContent = match.group(1) ?? '';
    // Strip HTML tags to get clean text
    final cleanText = preContent.replaceAll(RegExp(r'<[^>]*>'), '').trim();
    
    if (cleanText.contains('Input:') && cleanText.contains('Output:')) {
      String input = '';
      String output = '';
      String? explanation;
      
      final inputIdx = cleanText.indexOf('Input:');
      final outputIdx = cleanText.indexOf('Output:');
      final explanationIdx = cleanText.indexOf('Explanation:');
      
      if (inputIdx != -1 && outputIdx != -1) {
        input = cleanText.substring(inputIdx + 6, outputIdx).trim();
        if (explanationIdx != -1 && explanationIdx > outputIdx) {
          output = cleanText.substring(outputIdx + 7, explanationIdx).trim();
          explanation = cleanText.substring(explanationIdx + 12).trim();
        } else {
          output = cleanText.substring(outputIdx + 7).trim();
        }
        
        // Remove leading/trailing formatting characters
        if (input.startsWith('\n')) input = input.substring(1).trim();
        if (output.startsWith('\n')) output = output.substring(1).trim();
        
        list.add(LeetCodeExample(
          input: input,
          output: output,
          explanation: explanation,
        ));
      }
    }
  }
  
  // Fallback if no pre blocks matched
  if (list.isEmpty) {
    // Try to parse basic structure from plain text if it contains Example labels
    final cleanPlain = html.replaceAll(RegExp(r'<[^>]*>'), '');
    final exampleRegex = RegExp(r'Example \d+:\s*Input:\s*(.*?)\s*Output:\s*(.*?)(?=\s*Example \d+:|\s*Explanation:|\Z)', dotAll: true);
    final fallbackMatches = exampleRegex.allMatches(cleanPlain);
    for (final fm in fallbackMatches) {
      final input = fm.group(1)?.trim() ?? '';
      final output = fm.group(2)?.trim() ?? '';
      if (input.isNotEmpty && output.isNotEmpty) {
        list.add(LeetCodeExample(input: input, output: output));
      }
    }
  }
  
  return list;
}
