import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_guide/models/flutter_interview_model.dart';
import 'package:flutter_guide/models/flutter_notes.dart';

class NotesLoaders {
  Future<FlutterNotes> loadNotes() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final String jsonString = await rootBundle.loadString('assets/flutter_notes.json');
    return FlutterNotes.fromJson(json.decode(jsonString));
  }

  Future<FlutterInterview> loadInterview() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final String jsonString = await rootBundle.loadString('assets/flutter_interview.json');
    return FlutterInterview.fromJson(json.decode(jsonString));
  }
}