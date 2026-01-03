import 'package:flutter_guide/models/section.dart';

class NotesFilters {
  
  // Filter logic for Notes tab (assumes subsections have 'content')
List<Section> filterNotes(List<Section> sections,  String searchQuery) {
  if (searchQuery.isEmpty) return sections;

  return sections.where((section) {
    final titleMatch = section.title.toLowerCase().contains(searchQuery);
    final contentMatch = section.content.toLowerCase().contains(searchQuery);

    final subsectionMatch = section.subsections.any((sub) {
      final subTitleMatch = sub.title!.toLowerCase().contains(searchQuery);
      // Safely check if content exists and is searchable
      // final subContentMatch = sub.content?.toLowerCase().contains(_searchQuery) ?? false;
      return subTitleMatch;
    });

    return titleMatch || contentMatch || subsectionMatch;
  }).toList();
}

// Filter logic for Interview tab (assumes subsections have 'qa')
List<Section> filterInterview(List<Section> sections, String searchQuery) {
  if (searchQuery.isEmpty) return sections;

  return sections.where((section) {
    final titleMatch = section.title.toLowerCase().contains(searchQuery);

    final qaMatch = section.subsections.any((sub) {
      final subTitleMatch = sub.title!.toLowerCase().contains(searchQuery);

      if (sub.qa == null) return subTitleMatch;

      final questionAnswerMatch = sub.qa!.any((qa) =>
          qa.question.toLowerCase().contains(searchQuery) ||
          qa.answer.toLowerCase().contains(searchQuery));

      return subTitleMatch || questionAnswerMatch;
    });

    return titleMatch || qaMatch;
  }).toList();
}

}