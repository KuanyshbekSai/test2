import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quran_word.dart';

class WordService {
  static const _learnedKey = 'learned_words';

  static Future<List<int>> _loadLearnedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_learnedKey)?.map(int.parse).toList() ?? [];
  }

  static Future<void> _saveLearnedIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_learnedKey, ids.map((e) => e.toString()).toList());
  }

  static Future<List<QuranWord>> loadWords() async {
    final String jsonString = await rootBundle.loadString('assets/words.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final learnedIds = await _loadLearnedIds();
    return jsonList.map((json) {
      final word = QuranWord.fromJson(json);
      if (learnedIds.contains(word.id)) {
        word.isLearned = true;
      }
      return word;
    }).toList();
  }

  static Future<void> toggleLearned(QuranWord word) async {
    final ids = await _loadLearnedIds();
    if (ids.contains(word.id)) {
      ids.remove(word.id);
      word.isLearned = false;
    } else {
      ids.add(word.id);
      word.isLearned = true;
    }
    await _saveLearnedIds(ids);
  }

  static Future<int> learnedCount() async {
    final ids = await _loadLearnedIds();
    return ids.length;
  }

  static Future<int> totalCount() async {
    final String jsonString = await rootBundle.loadString('assets/words.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.length;
  }
}
