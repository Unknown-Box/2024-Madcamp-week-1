import 'dart:io';

import 'package:cardrepo/src/services/contacts.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:path/path.dart';
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
        colorScheme:
          ColorScheme.fromSeed(seedColor: Colors.white),
        canvasColor: Colors.white,
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
  final _key = GlobalKey<ExpandableFabState>();

  void switchPage(int newPageIndex) {
    setState(() {
      pageIndex = newPageIndex;
      switch(newPageIndex) {
        case 0:
          page = const Contact();
          title = 'My Contacts';
          break;
        case 1:
          page = const Cards();
          title = 'Business Cards';
          break;
        case 2:
          page = myInfoDetails();
          // page = Mypage();
          title = 'My Information';
          break;
        default:
          throw UnimplementedError('unimplemented page');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: Colors.white,
        title: Text(title),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'RobotoSerif',
          fontWeight: FontWeight.w800,
        ),
        elevation: 10.0,
        shadowColor: Color.fromARGB(152, 241, 241, 241),
      ),
      body: page,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(0, 0, 0, 2),
              offset: Offset(0, -2.0),
              blurRadius: 4,
              spreadRadius: 3.0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedFontSize: 13.0,
          unselectedFontSize: 14.0,
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: Color.fromARGB(255, 176, 176, 176),
          currentIndex: pageIndex,
          onTap: switchPage,
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