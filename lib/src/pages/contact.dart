import 'package:flutter/material.dart';
import 'package:cardrepo/src/services/contacts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  List<ContactModel> _contacts = [];
  final contactService = ContactService();

  @override
  void initState() {
    super.initState();
    contactService
      .listContacts()
      .then((contactlist) {
        setState(() {
          _contacts = [...contactlist];
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.95,
            child: SearchBar(
              elevation: WidgetStateProperty.all(0),
              trailing: const [
                Icon(Icons.search)
              ],
              constraints: const BoxConstraints(),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4)
              ),
              textStyle: WidgetStateProperty.all(
                Theme.of(context).textTheme.bodyLarge
              ),
              hintText: 'Search Contacts',
              onChanged: (value) async {
                final contacts = await contactService.listContacts();

                setState(() {
                  _contacts = contacts.where((contact) {
                    final terms = value.split(' ')
                                       .map((term) => term.toLowerCase());
                    final inName = terms.every((term) {
                      final fn = contact.fullName;

                      return fn.toLowerCase().contains(term);
                    });
                    final inTel = terms.every((term) {
                      final tel = contact.tel.replaceAll('-', '');

                      return tel.contains(term);
                    });
                    final inOrg = terms.every((term) {
                      final org = contact.org?.toLowerCase();

                      return org?.contains(term) ?? false;
                    });

                    return inName || inTel || inOrg;
                  }).toList();
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final dbDir = getDatabasesPath();
                  const dbName = "cardrepo.db";
                  final dbPath = '$dbDir/$dbName';
                  print("Reset");

                  deleteDatabase(dbPath);
                });
              },
              child: const Text('Reset')
            ),
            ElevatedButton(
              onPressed: () async {
                print(await getApplicationDocumentsDirectory());
                // await contactService.insertContact();
              },
              child: const Text('Click'),
            )
          ],
        ),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _contacts.length,
            itemBuilder: (BuildContext context, int idx) {
              final contact = _contacts[idx];

              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
                child: ContactCard(
                  fullName: contact.fullName,
                  tel: contact.tel,
                  email: contact.email,
                  org: contact.org,
                  position: contact.position,
                  extLink: contact.extLink,
                ),
              );
            },
            separatorBuilder: (BuildContext context, int idx) => const Divider(),
          ),
        )
      ],
    );
  }
}

class ContactCard extends StatefulWidget {
  final String fullName;
  final String tel;
  final String email;
  final String? org;
  final String? position;
  final String? extLink;
  final bool initialExtended;

  const ContactCard({
    super.key,
    required this.fullName,
    required this.tel,
    required this.email,
    this.org,
    this.position,
    this.extLink,
    this.initialExtended = false,
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool extended = false;

  toggle() {
    setState(() {
      extended = !extended;
    });
  }

  @override
  void initState() {
    super.initState();
    extended = widget.initialExtended;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            toggle();
          },
          icon: Icon(
            extended ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
          ),
        ),
        if (extended)
          ContactCardDetail(
            fullName: widget.fullName,
            tel: widget.tel,
            org: widget.org,
            position: widget.position,
            email: widget.email,
            extLink: widget.extLink,
          )
        else
          ContactCardSummary(
            fullName: widget.fullName,
            tel: widget.tel,
          )
      ],
    );

  }
}

class ContactCardSummary extends StatelessWidget {
  final String fullName;
  final String tel;
  // final Function handler;

  const ContactCardSummary({
    super.key,
    required this.fullName,
    required this.tel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Text(
            fullName,
            style: Theme.of(context).textTheme.titleMedium
          ),
          const Spacer(),
          Text(tel),
        ]
      ),
    );
  }
}

class ContactCardDetail extends StatelessWidget {
  final String fullName;
  final String tel;
  final String email;
  final String? org;
  final String? position;
  final String? extLink;

  const ContactCardDetail({
    super.key,
    required this.fullName,
    required this.tel,
    required this.email,
    this.org,
    this.position,
    this.extLink,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: Theme.of(context).textTheme.titleMedium
              ),
              if (org != null)
                Row(
                  children: [
                    Text(
                      org!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (position != null)
                      Row(
                        children: [
                          SizedBox(
                            width: 16,
                            child: Center(
                              child: Text(
                                '|',
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ),
                          ),
                          Text(
                            position!,
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        ]
                      )
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TEL',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),Text(
                            'EMAIL',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tel,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
