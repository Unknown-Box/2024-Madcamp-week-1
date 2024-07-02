import 'package:flutter/material.dart';

import 'package:cardrepo/src/theme/index.dart';
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
      theme: theme,
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
  int pageIndex = 1;
  Widget page = const Cards();
  String title = 'Business Cards';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        forceMaterialTransparency: true,
      ),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (value) {
          setState(() {
            pageIndex = value;
            switch(value) {
              case 0:
                page = const Contact();
                title = 'My Contacts';
                break;
              case 1:
                page = const Cards();
                title = 'Business Cards';
                break;
              case 2:
                page = const Mypage();
                title = 'Edit Your Information';
                break;
              default:
                throw UnimplementedError('unimplemented page');
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'mypage',
          ),
        ],
      ),
    );
  }
}