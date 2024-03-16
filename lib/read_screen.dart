import 'package:flutter/material.dart';

class ReadScreen extends StatelessWidget {
  const ReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text('Hannah Nala Chapter: 1'),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: ComicPage(),
    );
  }
}


class ComicPage extends StatelessWidget {
  final List<String> comicImages = [
    'images/halaman1.jpg',
    'images/halaman2.jpg',
    'images/halaman3.jpg',
    'images/halaman4.jpg',
    'images/halaman5.jpg',
    'images/halaman6.jpg',
    'images/halaman7.jpg',
    'images/halaman8.jpg',
    'images/halaman9.jpg',
    'images/halaman10.jpg',
    'images/halaman11.jpg',
    
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