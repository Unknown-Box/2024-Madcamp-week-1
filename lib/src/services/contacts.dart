import 'package:flutter/material.dart';
import 'package:path/path.dart';
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

  Future<List<ContactModel>> listContacts() async {
    final db = await repo.db;
    final data = await db.query(
      'CONTACTS',
      orderBy: "fn ASC"
    );
    final contacts = data.map(ContactModel.fromDict)
                         .toList();

    return contacts;
  }
}
