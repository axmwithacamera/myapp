import 'package:flutter/material.dart';

import 'package:myapp/admin.dart';

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
