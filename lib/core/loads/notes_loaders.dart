import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_guide/models/flutter_interview_model.dart';
import 'package:flutter_guide/models/flutter_notes.dart';
import 'package:flutter_guide/models/flutter_quiz.dart';

class NotesLoaders {
  Future<FlutterNotes> loadNotes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final String jsonString = await rootBundle.loadString('assets/jsons/flutter_notes.json');
    return FlutterNotes.fromJson(json.decode(jsonString));
  }

  Future<FlutterInterview> loadInterview() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final String jsonString = await rootBundle.loadString('assets/jsons/flutter_interview.json');
    return FlutterInterview.fromJson(json.decode(jsonString));
  }

  Future<QuizSet> loadQuiz() async {
   
    final raw = await rootBundle.loadString('assets/jsons/flutter_quiz.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    return QuizSet.fromJson(map);
  }
}