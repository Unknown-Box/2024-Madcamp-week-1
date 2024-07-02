import 'package:flutter/material.dart';
import 'package:cardrepo/src/services/contacts.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String query = '';
  String searchBy = 'all';
  List<ContactModel> contacts = [];
  final ContactService contactService = ContactService();

  @override
  void initState() {
    super.initState();

    contactService
      .listContacts()
      .then(updateContactList);
  }

  void updateContactList(List<ContactModel> newContats) {
    setState(() {
      contacts = [...newContats];
    });
  }

  void searchContacts() {
    late final Future<List<ContactModel>> result;

    switch(searchBy) {
      case 'all':
        result = contactService.searchContactsByNameOrOrg(query);
        break;

      case 'name':
        result = contactService.searchContactsByName(query);
        break;

      case 'company':
        result = contactService.searchContactsByOrg(query);
        break;

      default:
        throw UnimplementedError('unimplemented search param');
    }

    result.then(updateContactList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8
      ),
      child: Column(
        children: [
          Center(
            child: SearchBar(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4
                ),
              ),
              constraints: const BoxConstraints(),
              leading: const Icon(Icons.search),
              trailing: [
                DropdownButton(
                  value: searchBy,
                  items: [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text(
                        'all',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ),
                    DropdownMenuItem(
                      value: 'name',
                      child: Text(
                        'name',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ),
                    DropdownMenuItem(
                      value: 'company',
                      child: Text(
                        'company',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        searchBy = value;
                      });
                      searchContacts();
                    }
                  }
                )
              ],
              hintText: 'Search by name or company',
              elevation: const WidgetStatePropertyAll(4),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              ),
              textStyle: WidgetStatePropertyAll(
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                )
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                  searchContacts();
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (ctx, idx) {
                final contact = contacts[idx];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8
                  ),
                  child: ContactCard(
                    id: contact.id,
                    fullName: contact.fullName,
                    tel: contact.tel,
                    email: contact.email,
                    favorite: contact.favorite,
                    org: contact.org,
                    position: contact.position,
                    extLink: contact.extLink,
                    handler: searchContacts
                  ),
                );
              },
              separatorBuilder: (ctx, idx) => const Divider(
                height: 4,
              ),
              itemCount: contacts.length,
            ),
          )
        ],
      ),
    );
  }
}

class ContactCard extends StatefulWidget {
  final String id;
  final String fullName;
  final String tel;
  final String email;
  final bool favorite;
  final String? org;
  final String? position;
  final String? extLink;
  final void Function() handler;

  const ContactCard({
    super.key,
    required this.id,
    required this.fullName,
    required this.tel,
    required this.email,
    required this.favorite,
    this.org,
    this.position,
    this.extLink,
    required this.handler
  });

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactDetails(
              id: widget.id,
              fullName: widget.fullName,
              tel: widget.tel,
              email: widget.email,
              favorite: widget.favorite,
              org: widget.org,
              position: widget.position,
              extLink: widget.extLink,
            ),
          )
        ).then((_) {
          widget.handler();
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.fullName)
              ),

              Expanded(
                child: Text(
                  widget.tel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black45,
                  )
                )
              ),

              SizedBox(
                width: 24,
                height: 24,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),

          if (expanded)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Company',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF7D7D7D),
                            fontWeight: FontWeight.w400
                          ),
                        ),
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF7D7D7D),
                            fontWeight: FontWeight.w400
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.org ?? '',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF7F7F7F),
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      Text(
                        widget.email,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF7F7F7F),
                          fontWeight: FontWeight.w800
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ContactDetails extends StatefulWidget {
  final String id;
  final String fullName;
  final String tel;
  final String email;
  final bool favorite;
  final String? org;
  final String? position;
  final String? extLink;

  const ContactDetails({
    super.key,
    required this.id,
    required this.fullName,
    required this.tel,
    required this.email,
    required this.favorite,
    this.org,
    this.position,
    this.extLink,
  });

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  bool favorite = false;

  @override
  void initState() {
    super.initState();

    favorite = widget.favorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 16,
              ),
              child: AspectRatio(
                aspectRatio: 1.6,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/1.png'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(72, 98, 94, 94),
                        offset: Offset(0, 5.0),
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Color.fromARGB(72, 98, 94, 94),
                        offset: Offset(0, -1.0),
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 16,
              ),
              child: Text(
                widget.fullName,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  height: 1.20,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  shadows: const <Shadow>[
                    Shadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 3),
                      blurRadius: 3,
                    )
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 16,
              ),
              child: AspectRatio(
                aspectRatio: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Mobile',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF888888),
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                widget.tel,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Email',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF888888),
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                widget.email,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Company',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF888888),
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                widget.org ?? '',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Position',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF888888),
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                widget.position ?? '',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Additional Link',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF888888),
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                widget.extLink ?? 'https://www.instagram.com/in.cs.tagram/',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final contactService = ContactService();

                    await contactService.patchFavoriteById(
                      widget.id,
                      !favorite
                    );

                    setState(() {
                      favorite = !favorite;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4
                    ),
                    elevation: 4,
                  ),
                  child: SizedBox(
                    width: 38,
                    child: Icon(
                      favorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(width: 36),

                ElevatedButton(
                  onPressed: () async {
                    final contactService = ContactService();
                    final isRemoved = await contactService.removeContactById(widget.id);

                    if (isRemoved) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4
                    ),
                    elevation: 4,
                    backgroundColor: Colors.black,
                  ),
                  child: SizedBox(
                    width: 38,
                    child: Text(
                      'Delete',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
