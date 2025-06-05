import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_words/services/word_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('loadWords loads words from assets', () async {
    final words = await WordService.loadWords();
    expect(words.isNotEmpty, true);
  });

  test('toggleLearned toggles word learned state', () async {
    final words = await WordService.loadWords();
    final first = words.first;

    expect(first.isLearned, false);
    await WordService.toggleLearned(first);
    expect(first.isLearned, true);
    expect(await WordService.learnedCount(), 1);

    await WordService.toggleLearned(first);
    expect(first.isLearned, false);
    expect(await WordService.learnedCount(), 0);
  });

  test('totalCount matches length of loaded words', () async {
    final total = await WordService.totalCount();
    final words = await WordService.loadWords();
    expect(total, words.length);
  });
}
