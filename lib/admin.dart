import 'dart:io';

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/components/my_textfield.dart';
// import 'package:myapp/home.dart';
import 'package:myapp/login.dart';
import 'package:myapp/manage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  File? _image;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadNews() async {
    final String title = titleController.text;
    final String caption = captionController.text;
    final String body = bodyController.text;

    // Prepare data for upload
    Map<String, dynamic> newsData = {
      'title': title,
      'caption': caption,
      'body': body,
      'image': null,
    };

    // Upload image to Firebase Storage
    if (_image != null) {
      final imageRef = _storage.ref().child('images/${DateTime.now()}.jpg');
      await imageRef.putFile(_image!);
      final imageUrl = await imageRef.getDownloadURL();
      newsData['image'] = imageUrl;
    }

    try {
      // Upload the news item to Firestore
      await _firestore.collection('news').add(newsData);

      // Reset fields
      titleController.clear();
      captionController.clear();
      bodyController.clear();
      setState(() {
        _image = null;
      });

      // Show success message or perform further actions
    } catch (error) {
      // Handle error
    }
  }

  void openManagePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageNews()),
    );
  }

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
    // Implement your logout logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                openManagePage(context);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: const [
                    Icon(
                      Icons.edit_note_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Manage",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                logout(context);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Logout",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                controller: titleController,
                labelText: 'Title',
                hintText: 'Enter title',
                obscureText: false,
              ),
              const Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10, bottom: 10),
              ),
              MyTextField(
                controller: captionController,
                labelText: 'Caption',
                hintText: 'Enter caption',
                obscureText: false,
              ),
              const Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10, bottom: 10),
              ),
              MyTextField(
                controller: bodyController,
                labelText: 'Body',
                hintText: 'Enter body text',
                obscureText: false,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera),
                                  title: const Text('Take a photo'),
                                  onTap: () {
                                    _pickImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Choose from gallery'),
                                  onTap: () {
                                    _pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Select Image'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _uploadNews,
                    child: const Text('Upload News'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MaterialApp(
//     title: 'News App',
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     home: Home(),
//     routes: {
//       '/admin': (context) => const Admin(),
//     },
//   ));
// }
