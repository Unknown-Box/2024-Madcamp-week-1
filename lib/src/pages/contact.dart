import 'package:flutter/material.dart';
import './contacts.data.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  List<Map<String, String?>> contacts = data;
  List<Map<String, String?>> exposedContacts = data;

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
              constraints: BoxConstraints(),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(horizontal: 16, vertical: 4)
              ),
              textStyle: WidgetStateProperty.all(
                Theme.of(context).textTheme.bodyLarge
              ),
              hintText: "Search Contacts",
              onChanged: (value) {
                setState(() {
                  exposedContacts = contacts.where((contact) {
                    final terms = value.split(' ')
                                       .map((term) => term.toLowerCase());
                    final inName = terms.every((term) {
                      final fn = contact["first_name"];
                      final ln = contact["last_name"];

                      return '$fn $ln'.toLowerCase().contains(term);
                    });
                    final inTel = terms.every((term) {
                      final tel = contact["tel"]!.replaceAll('-', '');

                      return tel.contains(term);
                    });
                    final inOrg = terms.every((term) {
                      final org = contact["org"]!.toLowerCase();

                      return org.toLowerCase().contains(term);
                    });

                    return inName || inTel || inOrg;
                  }).toList();
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: exposedContacts.length,
            itemBuilder: (BuildContext context, int idx) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
                child: ContactCard(
                  firstName: exposedContacts[idx]["first_name"],
                  lastName: exposedContacts[idx]["last_name"],
                  tel: exposedContacts[idx]["tel"],
                  email: exposedContacts[idx]["email"],
                  org: exposedContacts[idx]["org"],
                  position: exposedContacts[idx]["position"],
                  extLink: exposedContacts[idx]["ext_link"],
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
  final String? firstName;
  final String? lastName;
  final String? tel;
  final String? email;
  final String? org;
  final String? position;
  final String? extLink;
  final bool initialExtended;

  const ContactCard({
    super.key,
    this.firstName,
    this.lastName,
    this.tel,
    this.email,
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
            firstName: widget.firstName,
            lastName: widget.lastName,
            tel: widget.tel,
            org: widget.org,
            position: widget.position,
            email: widget.email,
            extLink: widget.extLink,
          )
        else
          ContactCardSummary(
            firstName: widget.firstName,
            lastName: widget.lastName,
            tel: widget.tel,
          )
      ],
    );

  }
}

class ContactCardSummary extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final String? tel;
  // final Function handler;

  const ContactCardSummary({
    super.key,
    this.firstName,
    this.lastName,
    this.tel,
    // required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Text(
            '$firstName $lastName',
            style: Theme.of(context).textTheme.titleMedium
          ),
          const Spacer(),
          Text(tel ?? ""),
        ]
      ),
    );
  }
}

class ContactCardDetail extends StatelessWidget {
  final String? firstName;
  final String? lastName;
  final String? tel;
  final String? email;
  final String? org;
  final String? position;
  final String? extLink;

  const ContactCardDetail({
    super.key,
    this.firstName,
    this.lastName,
    this.tel,
    this.email,
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
                '$firstName $lastName',
                style: Theme.of(context).textTheme.titleMedium
              ),
              Row(
                children: [
                  Text(
                    org ?? '',
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
              const SizedBox(height: 8),
              if (tel != null)
                Row(
                  children: [
                    Text(
                      'TEL',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tel!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              if (email != null)
                Row(
                  children: [
                    Text(
                      'EMAIL',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      email!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
