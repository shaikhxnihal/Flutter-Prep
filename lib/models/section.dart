// models/section.dart - Shared models for both Notes and Interview Q&A
// Supports all current fields + new 'qa' for Interview sections

class Section {
  final int id;
  final String title;
  final String content;
  final List<Subsection> subsections;

  Section({
    required this.id,
    required this.title,
    required this.content,
    required this.subsections,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      subsections: (json['subsections'] as List)
          .map((sub) => Subsection.fromJson(sub as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Subsection {
  final String? title;           // Some subsections have title, some don't
  final List<String>? points;
  final String? code;
  final String? desc;
  final List<String>? steps;
  final List<WidgetInfo>? widgets;
  final List<QA>? qa;            // NEW: For Interview Q&A subsections

  Subsection({
    this.title,
    this.points,
    this.code,
    this.desc,
    this.steps,
    this.widgets,
    this.qa,
  });

  factory Subsection.fromJson(Map<String, dynamic> json) {
    return Subsection(
      title: json['title'] as String?,
      points: json['points'] != null ? List<String>.from(json['points']) : null,
      code: json['code'] as String?,
      desc: json['desc'] as String?,
      steps: json['steps'] != null ? List<String>.from(json['steps']) : null,
      widgets: json['widgets'] != null
          ? (json['widgets'] as List)
              .map((w) => WidgetInfo.fromJson(w as Map<String, dynamic>))
              .toList()
          : null,
      qa: json['qa'] != null
          ? (json['qa'] as List)
              .map((q) => QA.fromJson(q as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}

class WidgetInfo {
  final String name;
  final String desc;

  WidgetInfo({required this.name, required this.desc});

  factory WidgetInfo.fromJson(Map<String, dynamic> json) {
    return WidgetInfo(
      name: json['name'] as String,
      desc: json['desc'] as String,
    );
  }
}

class QA {
  final String question;
  final String answer;

  QA({required this.question, required this.answer});

  factory QA.fromJson(Map<String, dynamic> json) {
    return QA(
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
}