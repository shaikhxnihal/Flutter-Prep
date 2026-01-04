// lib/models/flutter_quiz.dart
import 'dart:convert';

class QuizSet {
  final List<QuizQuestion> beginner;
  final List<QuizQuestion> advanced;
  final List<QuizQuestion> interviewPrep;

  QuizSet({
    required this.beginner,
    required this.advanced,
    required this.interviewPrep,
  });

  factory QuizSet.fromJson(Map<String, dynamic> json) {
    List<QuizQuestion> parseList(String key) {
      final dynamic listData = json[key];
      if (listData == null || listData is! List) {
        return [];  // Handle null or wrong type
      }
      return (listData as List<dynamic>)
          .map((e) {
            if (e == null || e is! Map<String, dynamic>) {
              return null;  // Skip invalid
            }
            try {
              return QuizQuestion.fromJson(e as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing question for key $key: $e');
              return null;
            }
          })
          .where((q) => q != null)
          .cast<QuizQuestion>()
          .toList();
    }

    return QuizSet(
      beginner: parseList('Beginner'),
      advanced: parseList('Advanced'),
      interviewPrep: parseList('Interview Prep'),  // Fixed: space to match JSON
    );
  }

  /// Helper to get by level string: "Beginner" / "Advanced" / "InterviewPrep"
  List<QuizQuestion> questionsForLevel(String level) {
    switch (level) {
      case 'Beginner':
        return beginner;
      case 'Advanced':
        return advanced;
      case 'InterviewPrep':
        return interviewPrep;
      default:
        return beginner;
    }
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final String correct;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correct,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      correct: json['correct'] as String? ?? '',
    );
  }

  bool isCorrect(String selected) => selected == correct;
}

/// Utility to parse from raw JSON string if needed
QuizSet quizSetFromJsonString(String raw) {
  final map = json.decode(raw) as Map<String, dynamic>;
  return QuizSet.fromJson(map);
}
