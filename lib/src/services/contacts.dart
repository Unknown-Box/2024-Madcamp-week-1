import 'package:uuid/uuid.dart';
import 'package:cardrepo/src/repository/index.dart';
import 'package:uuid/v4.dart';

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
}

enum ContactOrderBy {
  fn,
  org,
}

enum ContactOrderDirection {
  asc,
  desc,
}

class ContactService {
  final repo = Repository();

  Future<List<ContactModel>> listContacts({
    ContactOrderBy orderBy = ContactOrderBy.fn,
    ContactOrderDirection orderDir = ContactOrderDirection.asc
  }) async {
    late final String orderByStatement;
    switch(orderBy) {
      case ContactOrderBy.fn:
        if (orderDir == ContactOrderDirection.asc) {
          orderByStatement = 'fn ASC';
        } else {
          orderByStatement = 'fn DESC';
        }
      case ContactOrderBy.org:
        if (orderDir == ContactOrderDirection.asc) {
          orderByStatement = 'org ASC';
        } else {
          orderByStatement = 'org DESC';
        }
    }

    final db = await repo.db;
    final data = await db.query(
      'CONTACTS',
      orderBy: orderByStatement
    );
    final contacts = data.map(ContactModel.fromDict)
                         .toList();

    return contacts;
  }
}
