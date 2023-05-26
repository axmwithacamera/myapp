import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/home.dart';

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

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _uploadNews() {
    final String title = titleController.text;
    final String caption = captionController.text;
    final String body = bodyController.text;

    setState(() {
      Home.newsList.insert(
        0,
        News(
          title: title,
          caption: caption,
          body: body,
          image: _image != null ? _image!.path : null,
        ),
      );
    });

    // Reset fields
    titleController.clear();
    captionController.clear();
    bodyController.clear();
    setState(() {
      _image = null;
    });
  }

  void _editNews(int index) {
    final News newsItem = Home.newsList[index];
    titleController.text = newsItem.title;
    captionController.text = newsItem.caption;
    bodyController.text = newsItem.body;
    _image = newsItem.image != null ? File(newsItem.image!) : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit News'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextFormField(
                  controller: captionController,
                  decoration: const InputDecoration(
                    labelText: 'Caption',
                  ),
                ),
                TextFormField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Body',
                  ),
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
              onPressed: () {
                setState(() {
                  final News editedNews = News(
                    title: titleController.text,
                    caption: captionController.text,
                    body: bodyController.text,
                    image: _image != null ? _image!.path : null,
                    isFavorite: newsItem.isFavorite,
                  );
                  Home.newsList[index] = editedNews;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNews(int index) {
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
                  Home.newsList.removeAt(index);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextFormField(
                  controller: captionController,
                  decoration: const InputDecoration(
                    labelText: 'Caption',
                  ),
                ),
                TextFormField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Body',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Text('Select Image'),
                ),
                ElevatedButton(
                  onPressed: _uploadNews,
                  child: const Text('Upload News'),
                ),
              ],
            ),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: Home.newsList.length,
            itemBuilder: (BuildContext context, int index) {
              final News newsItem = Home.newsList[index];
              return ListTile(
                title: Text(newsItem.title),
                subtitle: Text(newsItem.caption),
                leading: newsItem.image != null
                    ? Image.file(File(newsItem.image!))
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _editNews(index);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        _deleteNews(index);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
