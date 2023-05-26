// import 'package:flutter/material.dart';

// class News {
//   final String title;
//   final String caption;
//   final String body;
//   final String? image; // Nullable image property
//   bool isFavorite;

//   News({
//     required this.title,
//     required this.caption,
//     required this.body,
//     this.image,
//     this.isFavorite = false,
//   });
// }

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   List<News> newsList = [
//     News(
//       title: "News Title 1",
//       caption: "News Caption 1",
//       body: "News Body 1",
//       image: "assets/news_image_1.jpg", // Placeholder for image path
//     ),
//     News(
//       title: "News Title 2",
//       caption: "News Caption 2",
//       body: "News Body 2",
//       image: null, // case where no image is provided
//     ),
//     News(
//       title: "News Title 3",
//       caption: "News Caption 3",
//       body: "News Body 3",
//       image: "assets/news_image_3.jpg", // Placeholder for image path
//     ),
//     News(
//       title: "News Title 4",
//       caption: "News Caption 4",
//       body: "News Body 4",
//       image: "assets/news_image_4.jpg", // Placeholder for image path
//     ),
//     News(
//       title: "News Title 5",
//       caption: "News Caption 5",
//       body: "News Body 5",
//       image: "assets/news_image_5.jpg", // Placeholder for image path
//     ),
//   ];

//   void toggleFavorite(int index) {
//     setState(() {
//       newsList[index].isFavorite = !newsList[index].isFavorite;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("News App"),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//       ),
//       body: ListView.builder(
//         itemCount: newsList.length,
//         itemBuilder: (context, index) {
//           final newsItem = newsList[index];
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (newsItem.image != null)
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(
//                         8), // to round the corners a little
//                     child: Container(
//                       width: double.infinity,
//                       height: 200,
//                       color: Colors.grey[300],
//                       child: const Center(
//                         child: Text(
//                           'Image Placeholder',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         newsItem.title,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         newsItem.caption,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(newsItem.body),
//                       IconButton(
//                         icon: Icon(
//                           newsItem.isFavorite
//                               ? Icons.favorite
//                               : Icons.favorite_border,
//                           color:
//                               newsItem.isFavorite ? Colors.red : Colors.black,
//                         ),
//                         onPressed: () {
//                           toggleFavorite(index);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
