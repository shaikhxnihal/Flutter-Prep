import 'section.dart';

class FlutterInterview {
  final String title;
  final String version;
  final String description;
  final List<Section> sections;

  FlutterInterview({
    required this.title,
    required this.version,
    required this.description,
    required this.sections,
  });

  factory FlutterInterview.fromJson(Map<String, dynamic> json) {
    return FlutterInterview(
      title: json['title'] as String,
      version: json['version'] as String,
      description: json['description'] as String,
      sections: (json['sections'] as List)
          .map((s) => Section.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}