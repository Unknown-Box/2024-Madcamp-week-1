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
      // main font: 'Avenir' (assets/fonts/..)
      theme: ThemeData(
        fontFamily: 'Avenir',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      themeMode: ThemeMode.system,
      home: App(),
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
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.w800,
        ),
        forceMaterialTransparency: true,
      ),
      body: page,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(0, 0, 0, 1),
              offset: Offset(0, -2.0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedFontSize: 13.0,
          unselectedFontSize: 14.0,
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: Color.fromARGB(255, 139, 139, 139),
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
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/searchicon.png', width: 20, height: 20),
              activeIcon: Image.asset('assets/images/searchicon.png', width: 20, height: 20),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/mainicon.png', width: 25, height: 25),
              activeIcon: Image.asset('assets/images/mainicon.png', width: 25, height: 25),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/mypage.png', width: 20, height: 20),
              activeIcon: Image.asset('assets/images/mypage.png', width: 20, height: 20),
              label: 'Mypage',
            ),
          ],
        ),
      ),
    );
  }
}