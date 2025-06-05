import 'package:flutter/material.dart';
import '../models/quran_word.dart';
import '../services/word_service.dart';
class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late Future<List<QuranWord>> _wordsFuture;

  @override
  void initState() {
    super.initState();
    _wordsFuture = WordService.loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Прогресс')),
      body: FutureBuilder<List<QuranWord>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final words = snapshot.data!;
            final learned = words.where((w) => w.isLearned).length;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Выучено $learned из ${words.length} слов'),
                  SizedBox(height: 20),
                  LinearProgressIndicator(value: learned / words.length),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки прогресса'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
