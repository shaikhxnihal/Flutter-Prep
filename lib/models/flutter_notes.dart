import 'section.dart';

class FlutterNotes {
  final String title;
  final String version;
  final String description;
  final List<Section> sections;

  FlutterNotes({
    required this.title,
    required this.version,
    required this.description,
    required this.sections,
  });

  factory FlutterNotes.fromJson(Map<String, dynamic> json) {
    return FlutterNotes(
      title: json['title'] as String,
      version: json['version'] as String,
      description: json['description'] as String,
      sections: (json['sections'] as List)
          .map((s) => Section.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}