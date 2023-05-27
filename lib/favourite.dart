import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/home.dart';
import 'package:myapp/login.dart';

class Favourite extends StatelessWidget {
  const Favourite({Key? key}) : super(key: key);

  void openHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
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
    final List<News> favoriteNewsList =
        Home.newsList.where((news) => news.isFavorite).toList();

    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Favourite News"),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          drawer: Drawer(
            backgroundColor: Colors.blue,
            width: MediaQuery.of(context).size.width * 0.5,
            child: ListView(
              children: [
                InkWell(
                  onTap: () {
                    openHomePage(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        SizedBox(width: 16),
                        Text(
                          "Home",
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
          body: ListView.builder(
            itemCount: favoriteNewsList.length,
            itemBuilder: (context, index) {
              final newsItem = favoriteNewsList[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (newsItem.image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: double.infinity,
                          height: 230,
                          child: Image.file(
                            File(newsItem.image!),
                            fit: BoxFit.cover,
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
