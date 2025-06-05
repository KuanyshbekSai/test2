import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(QuranWordsApp());
}

class QuranWordsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '500 слов из Корана',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}
