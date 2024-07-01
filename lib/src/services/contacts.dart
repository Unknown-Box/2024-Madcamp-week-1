import './contacts.data.dart';

class ContactModel {
  final String id;
  final String fullName;
  final String tel;
  final String email;
  final String? org;
  final String? position;
  final String? extLink;

  ContactModel({
    required this.id,
    required this.fullName,
    required this.tel,
    required this.email,
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
      org: dict['org'],
      position: dict['position'],
      extLink: dict['ext_link']
    );
  }
}

enum ContactOrderBy {
  name,
  org,
}

enum ContactOrderDirection {
  asc,
  desc,
}

class ContactService {
  Future<List<ContactModel>> listContacts({
    ContactOrderBy orderBy = ContactOrderBy.name,
    ContactOrderDirection orderDir = ContactOrderDirection.asc
  }) async {
    final contacts = data.map((entry) => ContactModel.fromDict(entry))
                         .toList();
    contacts.sort((a, b) {
      if (orderDir == ContactOrderDirection.desc) {
        final tmp = a;
        a = b;
        b = tmp;
      }

      switch(orderBy) {
        case ContactOrderBy.name:
          final fnA = a.fullName;
          final fnB = b.fullName;

          return fnA.compareTo(fnB);
        case ContactOrderBy.org:
          final orgA = a.org ?? '';
          final orgB = b.org ?? '';

          return orgA.compareTo(orgB);
      }
    });

    return contacts;
  }
}
