// name(first, last), tel, email, image(biz card), 
// (opt)org, (opt)position, (opt)ext_link

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cardrepo/src/services/contacts.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class myInfoDetails extends StatefulWidget {
  final String id;
  final String fullName;
  final String tel;
  final String email;
  final String? org;
  final String? position;
  final String? extLink;

  const myInfoDetails({
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
  State<myInfoDetails> createState() => _myInfoDetailsState();
}

class _myInfoDetailsState extends State<myInfoDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12
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
            
            // Full Name display
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 7,
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
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromARGB(255, 193, 193, 193),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(72, 98, 94, 94),
                        offset: Offset(0, 3.0),
                        blurRadius: 5.0,
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
                child: Padding(
                  // detail box inner padding
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                  // detail column
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // contents: tel, email, comp, pos, url
                    children: [
                      // phone #
                      Container(
                        child: Row(
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
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                widget.tel,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ]                          
                        ),
                      ),
                      SizedBox(height:15),
                      // email
                      Container(
                        child: Row(
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
                                child: Text(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  widget.email,
                                  overflow: TextOverflow.ellipsis,  
                                ), 
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height:15),
                      // company
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
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
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ), 
                            )
                          ],
                        ),
                      ),
                      SizedBox(height:15),
                      // position
                      Container(
                        child: Row(
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
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height:15),
                      // url
                      Container(
                        child: Row(
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
                                  text: widget.extLink ?? 'https://www.instagram.com/in.cs.tagram/',
                                  style: TextStyle(color: Colors.black),
                                  linkStyle: TextStyle(color: Color.fromARGB(255, 72, 109, 174)),
                                )
                              )
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // edit and delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Edit Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => Mypage(
                          /*
                          myInfoDetails(
                            id: 'SELF',
                            fullName: '',
                            tel: '',
                            email: '',
                            org: '',
                            position: '',
                            extLink: '',
                          );
                          */
                        ),
                      ),
                    ).then((_) {
                      //widget.handler();
                    });
                  },
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
                  child: SizedBox(
                    width: 60,
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // QR Code (fake)
                ElevatedButton(
                  onPressed: () {
                    // void
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4
                    ),
                    elevation: 4,
                    backgroundColor: Colors.black
                  ),
                  child: SizedBox(
                    width: 60,
                    child: Text(
                      'QR Code',
                      style: TextStyle(color: Colors.white),
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


// editing screen
class Mypage extends StatefulWidget {
  String? fullName;
  String? tel;
  String? email;
  String? cardUrl;
  String? org;
  String? position;
  String? extLink;

  Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  File? _image;
  final TextEditingController _NameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  ContactService contactService = ContactService();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  void _saveContactInfo() async {
    String name = _NameController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    String org = _orgController.text;
    String position = _positionController.text;
    String url = _urlController.text;

    final isUpdated = await contactService.udpateMyContact(
      fullName: name, 
      tel: phone,
      email: email,
      org: org.isEmpty ? null : org,
      position: position.isEmpty ? null : position,
      extLink: url.isEmpty ? null : url,
    );
                    
    if (isUpdated) {
      print('Saved info: $name $phone $email $org $position $url');
    } else {
      print('No datas to be updated');
    }

  }

  @override
  void initState() {
    super.initState();
    _NameController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _orgController.addListener(() => setState(() {}));
    _positionController.addListener(() => setState(() {}));
    _urlController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 10.0,
        shadowColor: Color.fromARGB(152, 241, 241, 241),
      ),
      body: Center(
        child: SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.all(10),  
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //SizedBox(height: 3.0),
                  // biz card image with overlay button
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 9.0 / 5.0,
                        child: Container(           
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            image: DecorationImage(
                              image: _image != null
                                  ? FileImage(_image!)
                                  : AssetImage('assets/images/1.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(72, 98, 94, 94),
                                offset: Offset(0, 5.0),
                                blurRadius: 3.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // image add button positioning
                      Positioned(
                        right: -10,
                        bottom: 10,
                        child: buildAddImgButton(),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 10.0),
                  // name
                  Container(
                    width: 500,
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    child: Text(
                      'Full Name',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  buildName(),

                  SizedBox(height: 5.0),
                  // phone
                  Container(
                    width: 500,
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    child: Text(
                      'Phone Number',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  buildPhone(),                                    
                  
                  SizedBox(height: 5.0),
                  // email
                  Container(
                    width: 500,
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    child: Text(
                      'Email Address',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  buildEmail(),
                  
                  SizedBox(height: 5.0),
                  // organization
                  Container(
                    width: 500,
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    child: Text(
                      'Organization (Optional)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  buildOrg(),
                  
                  SizedBox(height: 5.0),
                  // position
                  Container(
                    width: 500,
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    child: Text(
                      'Position (Optional)', 
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  buildPos(),

                  SizedBox(height: 5.0),
                  // url
                  Container(
                    width: 500,
                    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                    child: Text(
                      'External Profile Link (Optional)',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.0),
                  buildUrl(),

                  SizedBox(height: 5.0),
                    // Save button
                  ElevatedButton(
                    onPressed: _saveContactInfo,
                    child: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 37, 37, 37),
                      foregroundColor: Colors.white,
                      elevation: 5,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),    
            ),
          )
    );
  }

  String? checkErrorText_Name() {
    if (_NameController.text == null || _NameController.text.isEmpty) {
      return 'Full Name is Required';
    }
    return null;
  }
  String? checkErrorText_phone() {
    if (_phoneController.text == null || _phoneController.text.isEmpty) {
      return 'Phone Number is Required';
    }
    return null;
  }

  String? checkErrorText_email() {
    if (_emailController.text == null || _emailController.text.isEmpty) {
      return 'Email is Required';
    }
    return null;
  }
  
  InputBorder _customBorder(double width, Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: width,
        color: color,
      ),
    );
  }

  Widget buildName() {
    var value = "";
    return TextFormField(
      controller: _NameController,
      validator: (value) {
        debugPrint('validator $value');
      },
      onChanged: (name) {
        value = name;
      },
      initialValue: widget.fullName,
      decoration: InputDecoration(
        errorBorder: _customBorder(1, const Color.fromARGB(255, 227, 90, 80)),
        focusedErrorBorder: _customBorder(1, const Color.fromARGB(255, 227, 90, 80)),
        errorText: checkErrorText_Name(),
        errorStyle: TextStyle(color: const Color.fromARGB(255, 227, 90, 80), fontSize: 12),
        hintText: 'Your First Name + Last Name',
        hintStyle: TextStyle(fontWeight: FontWeight.w300),
        border: OutlineInputBorder(),
        suffixIcon: _NameController.text.isEmpty
          ? Container(width: 0)
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _NameController.clear(),
            ),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
    );
  }
  
  Widget buildPhone() {
    var value = "";
    return TextFormField(
      controller: _phoneController,
      validator: (value) {
        debugPrint('validator $value');
      },
      onChanged: (phone) {
        value = phone;
      },
      initialValue: widget.tel,
      decoration: InputDecoration(
        errorBorder: _customBorder(1, const Color.fromARGB(255, 227, 90, 80)),
        focusedErrorBorder: _customBorder(1, const Color.fromARGB(255, 227, 90, 80)),
        errorText: checkErrorText_phone(),
        errorStyle: TextStyle(color: const Color.fromARGB(255, 227, 90, 80), fontSize: 12),
        hintText: '+123-456-7890',
        hintStyle: TextStyle(fontWeight: FontWeight.w300),
        border: OutlineInputBorder(),
        suffixIcon: _phoneController.text.isEmpty
          ? Container(width: 0)
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _phoneController.clear(),
            ),
      ),
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
    );
  }
  
  Widget buildEmail() {
    var value = "";
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        debugPrint('validator $value');
      },
      onChanged: (email) {
        value = email;
      },
      initialValue: widget.email,
      decoration: InputDecoration(
        errorBorder: _customBorder(1, const Color.fromARGB(255, 227, 90, 80)),
        focusedErrorBorder: _customBorder(1, const Color.fromARGB(255, 227, 90, 80)),
        errorText: checkErrorText_email(),
        errorStyle: TextStyle(color: const Color.fromARGB(255, 227, 90, 80), fontSize: 12),
        hintText: 'name@example.com',
        hintStyle: TextStyle(fontWeight: FontWeight.w300),
        border: OutlineInputBorder(),
        suffixIcon: _emailController.text.isEmpty
          ? Container(width: 0)
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _emailController.clear(),
            ),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
    );
  }
  
  Widget buildOrg() {
    var value = "";
    return TextFormField(
      controller: _orgController,
      onChanged: (org) {
        value = org;
      },
      initialValue: widget.org,
      decoration: InputDecoration(
        // hintText: 'organization',
        // hintStyle: TextStyle(fontWeight: FontWeight.w300),
        border: OutlineInputBorder(),
        suffixIcon: _orgController.text.isEmpty
          ? Container(width: 0)
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _orgController.clear(),
            ),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
    );
  }

  Widget buildPos() {
    var value = "";
    return TextFormField(
      controller: _positionController,
      onChanged: (pos) {
        value = pos;
      },
      initialValue: widget.position,
      decoration: InputDecoration(
        // hintText: 'Job Position',
        // hintStyle: TextStyle(fontWeight: FontWeight.w300),
        border: OutlineInputBorder(),
        suffixIcon: _positionController.text.isEmpty
          ? Container(width: 0)
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _positionController.clear(),
            ),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
    );
  }

  Widget buildUrl() {
    var value = "";
    return TextFormField(
      controller: _urlController,
      onChanged: (url) {
        value = url;
      },
      initialValue: widget.extLink,
      decoration: InputDecoration(
        hintText: 'www.example.com',
        hintStyle: TextStyle(fontWeight: FontWeight.w300),
        border: OutlineInputBorder(),
        suffixIcon: _urlController.text.isEmpty
          ? Container(width: 0)
          : IconButton(
              icon: Icon(Icons.close),
              onPressed: () => _urlController.clear(),
            ),
      ),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.done,
    );
  }

  // image edit button
  Widget buildAddImgButton() {
    return MaterialButton(
      onPressed: () {
        _pickImage();
      },
      color: Color.fromARGB(255, 20, 20, 20),
      textColor: Colors.white,
      child: Icon(
        Icons.add,
        size: 15,
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
      elevation: 5.0,
    );
  }
}



