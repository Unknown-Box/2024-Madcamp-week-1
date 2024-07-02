// images of business card using grid view
// business card ratio: 9:5

import 'package:flutter/material.dart';

class Cards extends StatefulWidget {
  const Cards({super.key});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {

  List<String> imagesList = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
    'assets/images/5.png',
    'assets/images/6.png',
    'assets/images/7.png',
    'assets/images/8.png',
    'assets/images/9.png',
    'assets/images/10.png',
    'assets/images/11.png',
    'assets/images/12.png',
    'assets/images/13.png',
    'assets/images/14.png',
    'assets/images/15.png',
    'assets/images/16.png',
    'assets/images/17.png',
    'assets/images/18.png',
    'assets/images/19.png',
    'assets/images/20.png' ,   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(      
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            child: GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              scrollDirection:Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 9.0 / 5.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,          
              ),
              itemCount: imagesList.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      image: AssetImage(imagesList[index]),
                      fit: BoxFit.fill,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(70, 211, 211, 211),
                        offset: Offset(0, -1.0),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Color.fromARGB(72, 98, 94, 94),
                        offset: Offset(0, 5.0),
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}