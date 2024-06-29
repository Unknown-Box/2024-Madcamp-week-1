// name(first, last), tel, email, image(biz card), 
// (opt)org, (opt)position, (opt)ext_link

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Mypage extends StatefulWidget {
  const Mypage({super.key});

  @override
  State<Mypage> createState() => _MypageState();
}

class _MypageState extends State<Mypage> {
  File? _image;
  
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [          
          // page description
          Container(
            width: 500,
            height: 30,
            padding: EdgeInsets.fromLTRB(20.0, 3.0, 20.0, 3.0),
            child: Text(
              'Edit Your Contact Information Here',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),          
          // personal info edit
          Container(          
            width: 500,
            margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 3.0),
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Color.fromARGB(246, 232, 213, 247),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(72, 98, 94, 94),
                  offset: Offset(0, 5.0),
                  blurRadius: 3.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
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
                    Positioned(
                      right: -10,
                      bottom: 10,
                      child: buildAddImgButton(),
                    ),
                  ],
                ),                
                
                SizedBox(height: 10.0),
                // first name
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    border: OutlineInputBorder()
                  ),
                ),
                
                SizedBox(height: 5.0),
                // last name
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                    border: OutlineInputBorder()
                  ),
                ),
                
                SizedBox(height: 5.0),
                // phone
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    border: OutlineInputBorder()
                  ),
                ),
                
                SizedBox(height: 5.0),
                // email
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder()
                  ),
                ),
                
                SizedBox(height: 5.0),
                // organization
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Organization (Optional)',
                    border: OutlineInputBorder()
                  ),
                ),
                
                SizedBox(height: 5.0),
                // position
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Position (Optional)',
                    border: OutlineInputBorder()
                  ),
                ),
                
                SizedBox(height: 5.0),
                // url
                TextFormField(
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'URL (Optional)',
                    border: OutlineInputBorder()
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddImgButton() {
    return MaterialButton(
      onPressed: () {
        _pickImage();
      },
      color: Colors.purple,
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
