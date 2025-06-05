import 'package:flutter/material.dart';
import 'learn_screen.dart';
import 'progress_screen.dart';
import 'card_screen.dart';
import '../services/word_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<int> _learned;
  late Future<int> _total;

  @override
  void initState() {
    super.initState();
    _learned = WordService.learnedCount();
    _total = WordService.totalCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('500 слов из Корана'),
      ),
      body: FutureBuilder<List<int>>(
        future: Future.wait([_learned, _total]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final learned = snapshot.data![0];
            final total = snapshot.data![1];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Выучено $learned из $total слов'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('📘 Учить слова'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CardScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('📜 Список слов'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LearnScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('📊 Прогресс'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProgressScreen()),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
