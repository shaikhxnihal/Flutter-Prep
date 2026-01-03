import 'package:flutter/material.dart';
import 'package:flutter_guide/models/section.dart';
import 'package:flutter_guide/screens/section_details_screen.dart';

class ShowMethods {
    void showAllNotes(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🆕 New note feature coming soon!'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF1F2937),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void showSectionDetails(BuildContext context, Section section, {bool isInterview = false}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SectionDetailsScreen(
        section: section,
        isInterview: isInterview,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}
}