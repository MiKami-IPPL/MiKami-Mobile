import 'package:flutter/material.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: const Text('Hannah Nala Chapter: 1'),
        iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Chapter 1'),
                  onTap: () {
                    // Navigate to chapter 1
                    Navigator.popAndPushNamed(context, '/chapter1');
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Chapter 2'),
                  onTap: () {
                    // Navigate to chapter 2
                    Navigator.popAndPushNamed(context, '/chapter2');
                  },
                ),
              ),
              // Add more chapters as needed
            ],
          ),
        ],
      ),
      body: ComicPage(),
    );
  }
}

class ComicPage extends StatelessWidget {
  final List<String> comicImages = [
    'assets/images/halaman1.jpg',
    'assets/images/halaman2.jpg',
    'assets/images/halaman3.jpg',
    'assets/images/halaman4.jpg',
    'assets/images/halaman5.jpg',
    'assets/images/halaman6.jpg',
    'assets/images/halaman7.jpg',
    'assets/images/halaman8.jpg',
    'assets/images/halaman9.jpg',
    'assets/images/halaman10.jpg',
    'assets/images/halaman11.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comicImages.length,
      itemBuilder: (context, index) {
        return Image.asset(comicImages[index]);
      },
    );
  }
}
