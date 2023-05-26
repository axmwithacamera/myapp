import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class News {
  final String title;
  final String caption;
  final String body;
  final String? image; // Nullable image property
  bool isFavorite;

  News({
    required this.title,
    required this.caption,
    required this.body,
    this.image,
    this.isFavorite = false,
  });
}

class Home extends StatefulWidget {
  static List<News> newsList = [];

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void toggleFavorite(int index) {
    setState(() {
      Home.newsList[index].isFavorite = !Home.newsList[index].isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("News App"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: Home.newsList.length,
        itemBuilder: (context, index) {
          final newsItem = Home.newsList[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (newsItem.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // to round the corners a little
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Text(
                          'Image Placeholder',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        newsItem.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        newsItem.caption,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(newsItem.body),
                      IconButton(
                        icon: Icon(
                          newsItem.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              newsItem.isFavorite ? Colors.red : Colors.black,
                        ),
                        onPressed: () {
                          toggleFavorite(index);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              ElevatedButton(
                onPressed: _uploadNews,
                child: const Text('Upload News'),
              ),
            ],
          ),
        ),
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
      home: const Home(),
      routes: {
        '/admin': (context) => const Admin(),
      },
    );
  }
}
