import 'package:flutter/material.dart';
import 'read_screen.dart';

class ChapterScreen extends StatelessWidget {
  const ChapterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.white),
            pinned: true,
            floating: true,
            expandedHeight: 250,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.favorite),
                color: Colors.white,
                onPressed: () {
                  // do something
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert_rounded),
                color: Colors.white,
                onPressed: () {
                  // do something
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hannah Nala\n',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'by Egi Mugia',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              background: Image.asset(
                'images/hannahBanner.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadScreen(),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text('Chapter ${1 + index}'),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}