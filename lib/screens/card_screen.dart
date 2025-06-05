import 'package:flutter/material.dart';
import '../models/quran_word.dart';
import '../services/word_service.dart';

class CardScreen extends StatefulWidget {
  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late Future<List<QuranWord>> _wordsFuture;

  @override
  void initState() {
    super.initState();
    _wordsFuture = WordService.loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Учить слова')),
      body: FutureBuilder<List<QuranWord>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final words = snapshot.data!.where((w) => !w.isLearned).toList();
            if (words.isEmpty) {
              return Center(child: Text('Все слова выучены!'));
            }
            return PageView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Card(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(word.arabic, style: TextStyle(fontSize: 48)),
                          SizedBox(height: 10),
                          Text(word.transcription,
                              style: TextStyle(fontSize: 20)),
                          SizedBox(height: 10),
                          Text(word.translation, style: TextStyle(fontSize: 20)),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              await WordService.toggleLearned(word);
                              setState(() {
                                _wordsFuture = WordService.loadWords();
                              });
                            },
                            child: Text('Отметить выученным'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки слов'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
