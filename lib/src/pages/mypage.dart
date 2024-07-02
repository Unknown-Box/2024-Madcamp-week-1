// name(first, last), tel, email, image(biz card), 
// (opt)org, (opt)position, (opt)ext_link
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cardrepo/src/services/contacts.dart';
import 'dart:io';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

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
      body: Center(
        child: SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.all(10),  
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 3.0),
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

  Widget buildName() {
    return TextFormField(
      controller: _NameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Full Name is Required';
        }
        return null;
      },
      decoration: InputDecoration(
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
    return TextFormField(
      controller: _phoneController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Phone Number is Required';
        }
        return null;
      },
      decoration: InputDecoration(
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
    return TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is Required';
        }
        return null;
      },
      decoration: InputDecoration(
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
    return TextFormField(
      controller: _orgController,
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
    return TextFormField(
      controller: _positionController,
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
    return TextFormField(
      controller: _urlController,
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
