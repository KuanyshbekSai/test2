import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/quran_word.dart';

class WordService {
  static Future<List<QuranWord>> loadWords() async {
    final String jsonString = await rootBundle.loadString('assets/words.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => QuranWord.fromJson(json)).toList();
  }
}
