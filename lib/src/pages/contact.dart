import 'package:flutter/material.dart';
import 'package:cardrepo/src/services/contacts.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String searchBy = 'all';
  List<ContactModel> contacts = [];
  final ContactService contactService = ContactService();

  @override
  void initState() {
    super.initState();

    contactService
      .listContacts()
      .then((initialContacts) async {
        setState(() {
          contacts = initialContacts;
        });
      });
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
                  vertical: 2
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
                        'All',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ),
                    DropdownMenuItem(
                      value: 'name',
                      child: Text(
                        'Name',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ),
                    DropdownMenuItem(
                      value: 'company',
                      child: Text(
                        'Company',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        searchBy = value;
                      });
                    }
                  }
                )
              ],
              hintText: 'Search Contacts',
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
                late final Future<List<ContactModel>> result;

                switch(searchBy) {
                  case 'all':
                    result = contactService.searchContactsByNameOrOrg(value);
                    break;

                  case 'name':
                    result = contactService.searchContactsByName(value);
                    break;

                  case 'company':
                    result = contactService.searchContactsByOrg(value);
                    break;

                  default:
                    throw UnimplementedError('unimplemented search param');
                }

                result.then((queriedContacts) {
                  setState(() {
                    contacts = queriedContacts;
                  });
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
                    org: contact.org,
                    position: contact.position,
                    extLink: contact.extLink,
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
  final String? org;
  final String? position;
  final String? extLink;

  const ContactCard({
    super.key,
    required this.id,
    required this.fullName,
    required this.tel,
    required this.email,
    this.org,
    this.position,
    this.extLink,
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
              org: widget.org,
              position: widget.position,
              extLink: widget.extLink,
            ),
          )
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.fullName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.tel,
                  style: TextStyle(
                    color: Color.fromARGB(255, 112, 112, 112),
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                  ),
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
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(
                        widget.email,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF7F7F7F),
                          fontWeight: FontWeight.w600
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

class ContactDetails extends StatelessWidget {
  final String id;
  final String fullName;
  final String tel;
  final String email;
  final String? org;
  final String? position;
  final String? extLink;

  const ContactDetails({
    super.key,
    required this.id,
    required this.fullName,
    required this.tel,
    required this.email,
    this.org,
    this.position,
    this.extLink,
  });

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 10,
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
                vertical: 10,
              ),
              child: Text(
                fullName,
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
                vertical: 10,
              ),
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
                    vertical: 2,
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
                            child: SelectableText(
                              tel,
                              //overflow: TextOverflow.ellipsis, 
                            ),                         
                          ),
                          IconButton(
                            icon: Icon(Icons.copy, color: Colors.grey, size: 12.0),
                            onPressed: () async{
                              await Clipboard.setData(
                                new ClipboardData(text: tel)
                              );
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(
                                    "Copied to Clipboard!",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500),
                                    ),
                                  actions: [
                                    TextButton(
                                      child: Text('close'), 
                                      onPressed: () => Navigator.of(context).pop(),
                                    )
                                  ],
                                )
                              );
                            },
                          ),
                        ]                          
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
                            child: Container(
                              child: SelectableText(
                                email,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                ), 
                              ),
                            ), 
                          ),
                          IconButton(
                            icon: Icon(Icons.copy, color: Colors.grey, size: 12.0),
                            onPressed: () async{
                              await Clipboard.setData(
                                new ClipboardData(text: email)
                              );
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(
                                    "Copied to Clipboard!",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500),
                                    ),
                                  actions: [
                                    TextButton(
                                      child: Text('close'), 
                                      onPressed: () => Navigator.of(context).pop(),
                                    )
                                  ],
                                )
                              );
                            },
                          ),
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
                              org ?? '',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600
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
                              position ?? '',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600
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
                                'URL',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF888888),
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Linkify(
                                onOpen: (link) async {
                                  if (!await launchUrl(Uri.parse(link.url))) {
                                    throw Exception('Could not launch ${link.url}');
                                  }
                                },
                                overflow: TextOverflow.ellipsis,
                                text: extLink ?? 'https://www.instagram.com/in.cs.tagram/',
                                style: TextStyle(color: Colors.black),
                                linkStyle: TextStyle(color: Color.fromARGB(255, 72, 109, 174)),
                              )
                            )
                          ],
                        ),
                    ],
                    ),
                  ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4
                    ),
                    elevation: 4,
                  ),
                  child: const SizedBox(
                    width: 40,
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4
                    ),
                    elevation: 4,
                    backgroundColor: Colors.black,
                  ),
                  child: SizedBox(
                    width: 40,
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}


