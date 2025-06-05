import 'package:flutter/material.dart';
import '../models/quran_word.dart';
import '../services/word_service.dart';

class LearnScreen extends StatefulWidget {
  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  late Future<List<QuranWord>> _wordsFuture;

  @override
  void initState() {
    super.initState();
    _wordsFuture = WordService.loadWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Слова')),
      body: FutureBuilder<List<QuranWord>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final words = snapshot.data!;
            return ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];
                return ListTile(
                  title: Text(word.arabic, style: TextStyle(fontSize: 24)),
                  subtitle: Text('${word.transcription} — ${word.translation}'),
                  trailing: Icon(
                    word.isLearned ? Icons.check_circle : Icons.circle_outlined,
                    color: word.isLearned ? Colors.green : Colors.grey,
                  ),
                  onTap: () async {
                    await WordService.toggleLearned(word);
                    setState(() {});
                  },
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
