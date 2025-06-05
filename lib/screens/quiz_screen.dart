import 'dart:math';
import 'package:flutter/material.dart';
import '../models/quran_word.dart';
import '../services/word_service.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<QuranWord>> _wordsFuture;
  final Random _random = Random();
  List<QuranWord> _words = [];
  late QuranWord _currentWord;
  List<QuranWord> _options = [];
  int _index = 0;
  int _score = 0;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _wordsFuture = WordService.loadWords();
  }

  void _prepareQuestion() {
    _currentWord = _words[_index];
    _options = [_currentWord];
    _words.shuffle();
    for (final w in _words) {
      if (_options.length >= 4) break;
      if (w.id != _currentWord.id) {
        _options.add(w);
      }
    }
    _options.shuffle();
  }

  void _answer(QuranWord answer) {
    if (_answered) return;
    setState(() {
      _answered = true;
      if (answer.id == _currentWord.id) {
        _score++;
      }
    });
  }

  void _next() {
    if (_index < _words.length - 1) {
      setState(() {
        _index++;
        _answered = false;
        _prepareQuestion();
      });
    } else {
      setState(() {
        _index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Проверка знаний')),
      body: FutureBuilder<List<QuranWord>>( 
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_words.isEmpty) {
              _words = List<QuranWord>.from(snapshot.data!);
              _words.shuffle();
              _prepareQuestion();
            }
            if (_index >= _words.length) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ваш результат: \$_score / \${_words.length}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _index = 0;
                          _score = 0;
                          _answered = false;
                          _words.shuffle();
                          _prepareQuestion();
                        });
                      },
                      child: const Text('Начать заново'),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _currentWord.arabic,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(height: 20),
                  ..._options.map((option) {
                    final isCorrect = option.id == _currentWord.id;
                    final Color? color = _answered
                        ? (isCorrect ? Colors.green : Colors.red)
                        : null;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                        ),
                        onPressed: () => _answer(option),
                        child: Text(option.translation),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  if (_answered)
                    ElevatedButton(
                      onPressed: _next,
                      child: const Text('Далее'),
                    ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки слов'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
