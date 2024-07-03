import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cardrepo/src/repository/index.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ContactModel {
  final String id;
  final String fullName;
  final String tel;
  final String email;
  final String cardUrl;
  final bool favorite;
  final String? org;
  final String? position;
  final String? extLink;

  ContactModel({
    required this.id,
    required this.fullName,
    required this.tel,
    required this.email,
    required this.cardUrl,
    required this.favorite,
    this.org,
    this.position,
    this.extLink
  });

  factory ContactModel.fromDict(Map<String, dynamic> dict) {
    return ContactModel(
      id: dict['id'],
      fullName: dict['fn']!,
      tel: dict['tel']!,
      email: dict['email']!,
      cardUrl: dict['card_url']!,
      favorite: dict['favorite'] == 1,
      org: dict['org'],
      position: dict['position'],
      extLink: dict['ext_link']
    );
  }

  factory ContactModel.placeholder() {
    final uuid4Generator = UuidV4();

    return ContactModel(
      id: uuid4Generator.generate(),
      fullName: 'Full Name',
      tel: 'Tel',
      email: 'Email',
      cardUrl: 'cards/url',
      favorite: false
    );
  }

  Map<String, dynamic> toDict() {
    return {
      'id': id,
      'fn': fullName,
      'tel': tel,
      'email': email,
      'card_url': cardUrl,
      'favorite': favorite ? 1 : 0,
      'org': org,
      'position': position,
      'ext_link': extLink
    };
  }
}

class ContactService {
  final repo = Repository();
  final uuid4Generator = const UuidV4();

  Future<ContactModel?> getContactById(String id) async {
    final db = await repo.db;
    final results = await db.query(
      'CONTACTS',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return results.isEmpty ? null : ContactModel.fromDict(results[0]);
  }

  Future<void> insertContact({
    required String fullName,
    required String tel,
    required String email,
    required File cardImg,
    String? org,
    String? position,
    String? extLink
  }) async {
    final db = await repo.db;
    final uuid4 = uuid4Generator.generate();
    final appDocDir = await getApplicationDocumentsDirectory();
    final cardDirPath = join(appDocDir.path, 'cards');
    final cardDir = Directory(cardDirPath);

    if (!await cardDir.exists()) {
      await cardDir.create();
    }

    final cardPath = setExtension(
      join(cardDir.path, uuid4),
      extension(cardImg.path)
    );

    await cardImg.copy(cardPath);

    try {
      final contact = ContactModel(
        id: uuid4,
        fullName: fullName,
        tel: tel,
        email: email,
        cardUrl: cardPath,
        favorite: false,
        org: org,
        position: position,
        extLink: extLink
      );

      await db.insert(
        'CONTACTS',
        contact.toDict()
      );
    } catch(e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> updateContactById(
    String id,
    {
      String? fullName,
      String? tel,
      String? email,
      String? org,
      String? position,
      String? extLink
    }
  ) async {
    final db = await repo.db;
    final record = {
      'fn': fullName,
      'tel': tel,
      'email': email,
      'org': org,
      'position': position,
      'extLink': extLink
    };
    record.removeWhere((_, value) => value == null);
    final modifiedCnt = await db.update(
      'CONTACTS',
      record,
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    return modifiedCnt == 1;
  }

  Future<bool> removeContactById(String id) async {
    final db = await repo.db;
    final removedCnt = await db.delete(
      'CONTACTS',
      where: 'id = ?',
      whereArgs: [id],
    );

    return removedCnt == 1;
  }

  Future<List<ContactModel>> listContacts() async {
    final db = await repo.db;
    final results = await db.query(
      'CONTACTS',
      where: 'id != ?',
      whereArgs: ['SELF'],
      orderBy: 'created_at DESC',
    );
    final contacts = results.map(ContactModel.fromDict)
                            .toList();

    return contacts;
  }

  Future<List<ContactModel>> searchContactsByNameOrOrg(
    String term
  ) async {
    final db = await repo.db;
    final results = await db.query(
      'CONTACTS',
      where: 'id != ? AND fn LIKE ? OR org LIKE ?',
      whereArgs: ['SELF', '%$term%', '%$term%'],
      orderBy: 'fn ASC'
    );
    final contacts = results.map(ContactModel.fromDict)
                            .toList();

    return contacts;
  }

  Future<List<ContactModel>> searchContactsByName(
    String name
  ) async {
    final db = await repo.db;
    final results = await db.query(
      'CONTACTS',
      where: 'id != ? AND fn LIKE ?',
      whereArgs: ['SELF', '%$name%'],
      orderBy: 'fn ASC'
    );
    final contacts = results.map(ContactModel.fromDict)
                            .toList();

    return contacts;
  }

  Future<List<ContactModel>> searchContactsByOrg(
    String org
  ) async {
    final db = await repo.db;
    final results = await db.query(
      'CONTACTS',
      where: 'id != ? AND org LIKE ?',
      whereArgs: ['SELF', '%$org%'],
      orderBy: 'org ASC, fn ASC'
    );
    final contacts = results.map(ContactModel.fromDict)
                            .toList();

    return contacts;
  }

  Future<ContactModel?> getMyContact() async {
    // final db = await repo.db;
    // final results = await db.query(
    //   'CONTACTS',
    //   where: 'id = ?',
    //   whereArgs: ['SELF'],
    //   limit: 1,
    // );

    // return results.isEmpty ? null : ContactModel.fromDict(results[0]);

    return await getContactById('SELF');
  }

  Future<bool> udpateMyContact({
    String? fullName,
    String? tel,
    String? email,
    String? org,
    String? position,
    String? extLink
  }) async {
    final db = await repo.db;
    final record = {
      'id': 'SELF',
      'fn': fullName,
      'tel': tel,
      'email': email,
      'card_url': '',
      'favorite': 0,
      'org': org,
      'position': position,
      'ext_link': extLink
    };
    record.removeWhere((_, value) => value == null);

    try {
      await db.insert(
        'CONTACTS',
        record,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch(_) {
      return false;
    }
  }

  Future<bool> patchFavoriteById(String id, bool favorite) async {
    final db = await repo.db;

    try {
      final isUpdated = await db.update(
        'CONTACTS',
        {'favorite': favorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id]
      );

      return isUpdated == 1;
    } catch(_) {
      return false;
    }
  }

  Future<ContactModel?> fromCardImage(File img) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: 'AIzaSyDKBTHMsMURCRTrTP11DyuADrBgQkpz1bI'
      );
      final prompt = TextPart(
        'parse the business card and return single line json file given as follows: {"full_name": "Micheal Wade", "tel": "123-4567-6789", "email": "example@mail.com", "company": "Apple", "position": "marketer", "ext_link": null}. you have to get full name, telephone number, email address of the card\'s owner, also company name and position may be required. if there is any external link, returns it, too. '
      );
      final imgPrompt = DataPart('image/jpeg', await img.readAsBytes());
      final resp = await model.generateContent(
        [Content.multi([prompt, imgPrompt])]
      );
      final result = resp.text!;
      final linesCnt = '\n'.allMatches(result).length;
      late Map<String, dynamic> data;

      if (result.startsWith('```json')) {
        data = jsonDecode(result.substring(8, result.length - 3));
      } else {
        data = jsonDecode(result);
      }

      return ContactModel(
        id: uuid4Generator.generate(),
        fullName: data['full_name'] ?? '',
        tel: data['tel'] ?? '',
        email: data['email'] ?? '',
        cardUrl: '',
        favorite: false,
        org: data['org'],
        position: data['position'],
        extLink: data['ext_link'],
      );
    } catch(e) {
      print(e);
      return null;
    }
  }
}
