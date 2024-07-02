import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/v4.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cardrepo/src/repository/index.dart';

class ContactModel {
  final String id;
  final String fullName;
  final String tel;
  final String email;
  final String cardUrl;
  final String? org;
  final String? position;
  final String? extLink;

  ContactModel({
    required this.id,
    required this.fullName,
    required this.tel,
    required this.email,
    required this.cardUrl,
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
      cardUrl: dict['card_url'],
      org: dict['org'],
      position: dict['position'],
      extLink: dict['ext_link']
    );
  }

  Map<String, dynamic> toDict() {
    return {
      "id": id,
      "fn": fullName,
      "tel": tel,
      "email": email,
      "card_url": cardUrl,
      "org": org,
      "position": position,
      "ext_link": extLink
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
    required XFile cardImg,
    String? org,
    String? position,
    String? extLink
  }) async {
    final db = await repo.db;
    final uuid4 = uuid4Generator.generate();
    final cardImgDir = await getApplicationDocumentsDirectory();
    final cardImgPath = join(cardImgDir.path, 'card_imgs', uuid4);

    try {
      final contact = ContactModel(
        id: uuid4,
        fullName: fullName,
        tel: tel,
        email: email,
        cardUrl: cardImgPath,
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
      orderBy: "fn ASC",
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
      where: "fn LIKE ? OR org LIKE ?",
      whereArgs: ['%$term%', '%$term%'],
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
      where: "fn LIKE ?",
      whereArgs: ['%$name%'],
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
      where: "org LIKE ?",
      whereArgs: ['%$org%'],
      orderBy: 'org ASC, fn ASC'
    );
    final contacts = results.map(ContactModel.fromDict)
                            .toList();

    return contacts;
  }

  Future<ContactModel?> getMyContact() async {
    final db = await repo.db;
    final results = await db.query(
      'CONTACTS',
      where: 'id = ?',
      whereArgs: ['SELF'],
      limit: 1,
    );

    return results.isEmpty ? null : ContactModel.fromDict(results[0]);
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
      'org': org,
      'position': position,
      'extLink': extLink
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
}
