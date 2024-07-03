// images of business card using grid view
// business card ratio: 9:5

import 'dart:io';

import 'package:cardrepo/src/services/contacts.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Cards extends StatefulWidget {
  const Cards({super.key});

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  List<ContactModel> contacts = [];
  final contactService =  ContactService();

  @override
  void initState() {
    super.initState();

    contactService
      .listContacts()
      .then((initialContacts) {
        setState(() {
          contacts = initialContacts;
        });
      });
  }

  // List<String> imagesList = [
  //   'assets/images/1.png',
  //   'assets/images/2.png',
  //   'assets/images/3.png',
  //   'assets/images/4.png',
  //   'assets/images/5.png',
  //   'assets/images/6.png',
  //   'assets/images/7.png',
  //   'assets/images/8.png',
  //   'assets/images/9.png',
  //   'assets/images/10.png',
  //   'assets/images/11.png',
  //   'assets/images/12.png',
  //   'assets/images/13.png',
  //   'assets/images/14.png',
  //   'assets/images/15.png',
  //   'assets/images/16.png',
  //   'assets/images/17.png',
  //   'assets/images/18.png',
  //   'assets/images/19.png',
  //   'assets/images/20.png' ,
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
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
                  itemCount: contacts.length,
                  itemBuilder: (BuildContext context, int index){
                    final contact = contacts[index];
                    final imgPath = contact.cardUrl;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(
                          // image: AssetImage(imagesList[index]),
                          image: imgPath.isEmpty
                            ? AssetImage('assets/images/${index % 20 + 1}.png')
                            : FileImage(File(imgPath)),
                          fit: BoxFit.fill,
                        ),
                        boxShadow: const [
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
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: const Icon(Icons.add),
                iconSize: 32,
                color: Colors.white,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.black),
                ),
                onPressed: () async {
                  try {
                    final pics = await CunningDocumentScanner.getPictures(
                      noOfPages: 1,
                      isGalleryImportAllowed: true
                    );
                    final pic = pics?.firstOrNull;

                    if (pic == null) {
                      return;
                    }

                    final picFile = File(pic);
                    final parsed = await contactService.fromCardImage(picFile);
                    final contact = parsed ?? ContactModel.placeholder();

                    await contactService.insertContact(
                      fullName: contact.fullName,
                      tel: contact.tel,
                      email: contact.email,
                      cardImg: picFile,
                      org: contact.org,
                      position: contact.position,
                      extLink: contact.extLink
                    );

                    contactService
                      .listContacts()
                      .then((updatedContacts) {
                        setState(() {
                          contacts = updatedContacts;
                        });
                      });
                  } catch(e) {
                    print(e);
                  }
                },
              ),
            ),
          ),
        ]
      ),
    );
  }
}