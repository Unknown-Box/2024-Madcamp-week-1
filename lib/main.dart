import 'package:flutter/material.dart';

import './src/pages/cards.dart';
import './src/pages/contact.dart';
import './src/pages/mypage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  String _title = 'upper banner title';

  var _index = 0;
  List _pages = [
    Contact(),
    Cards(),
    Mypage(),
  ];
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
            print(_index);
          });
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.phone), label: 'CONTACT'),
          BottomNavigationBarItem(icon: const Icon(Icons.image), label: 'CARDS'),
          BottomNavigationBarItem(icon: const Icon(Icons.account_circle_rounded), label: 'MY'),
        ],
      ),
    );
  }
}