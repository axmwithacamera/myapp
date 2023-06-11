import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/admin.dart';
import 'package:myapp/components/my_textfield.dart';
import 'package:myapp/login.dart';

class ManageNews extends StatefulWidget {
  const ManageNews({Key? key}) : super(key: key);

  @override
  State<ManageNews> createState() => _ManageNewsState();
}

class _ManageNewsState extends State<ManageNews> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  File? _image;

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImage(File? image, String newsId) async {
    if (image == null) return null;

    // Create a reference to the image file in Firebase Storage
    Reference ref = storage.ref().child('images/$newsId.jpg');

    // Upload the image file to Firebase Storage
    UploadTask uploadTask = ref.putFile(image);

    // Get the download URL of the uploaded image
    TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    return snapshot.ref.getDownloadURL();
  }

  void _editNews(int index, DocumentSnapshot newsSnapshot) {
    final newsItem = newsSnapshot.data() as Map<String, dynamic>;
    titleController.text = newsItem['title'];
    captionController.text = newsItem['caption'];
    bodyController.text = newsItem['body'];
    _image = newsItem['image'] != null ? File(newsItem['image']) : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit News'),
          content: SingleChildScrollView(
            child: Column(
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
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text('Select Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final editedNews = {
                  'title': titleController.text,
                  'caption': captionController.text,
                  'body': bodyController.text,
                  'isFavorite': newsItem['isFavorite'],
                };

                if (_image != null) {
                  String newsId =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  String? imageUrl = await _uploadImage(_image, newsId);
                  editedNews['image'] = imageUrl;
                } else {
                  editedNews['image'] = null;
                }

                newsSnapshot.reference.update(editedNews);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNews(int index, DocumentSnapshot newsSnapshot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete News'),
          content: const Text('Are you sure you want to delete this news?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Delete the news item from Firestore
                  newsSnapshot.reference.delete();
                });
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void openAdminPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Admin()),
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
        title: const Text('Manage News'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        width: MediaQuery.of(context).size.width * 0.5,
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                openAdminPage(context);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: const [
                    Icon(
                      Icons.file_upload_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Upload",
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('news').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching news'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final newsList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final newsSnapshot = newsList[index];
              final newsItem = newsSnapshot.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(newsItem['title']),
                subtitle: Text(newsItem['caption']),
                leading: newsItem['image'] != null
                    ? Image.network(newsItem['image'])
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _editNews(index, newsSnapshot);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteNews(index, newsSnapshot);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ManageNews(),
      routes: {
        '/login': (context) => const Login(),
      },
    );
  }
}
