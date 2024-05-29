import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'read_screen.dart';

class ChapterList extends StatefulWidget {
  const ChapterList({Key? key}) : super(key: key);

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prefs,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final SharedPreferences prefs = snapshot.data as SharedPreferences;
          return Scaffold(
            body: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      iconTheme: const IconThemeData(color: Colors.white),
                      pinned: true,
                      floating: true,
                      expandedHeight: 250,
                      actions: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.favorite),
                          color: Colors.white,
                          onPressed: () {
                            // do something
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert_rounded),
                          color: Colors.white,
                          onPressed: () {
                            // do something
                          },
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        title: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'title',
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
                        background: Image.network(
                          '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      delegate: _SliverAppBarDelegate(
                        const TabBar(
                          indicatorColor: Colors.red,
                          tabs: [
                            Tab(text: 'Preview'),
                            Tab(text: 'Chapter List'),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    // Single Scroll
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSynopsisContainer(), // Add this line
                          Image.asset(
                            'assets/images/halaman1.jpg',
                            fit: BoxFit.cover,
                          ),
                          Image.asset(
                            'assets/images/halaman2.jpg',
                            fit: BoxFit.cover,
                          ),
                          Image.asset(
                            'assets/images/halaman3.jpg',
                            fit: BoxFit.cover,
                          ),
                          Image.asset(
                            'assets/images/halaman4.jpg',
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),

                    // Sliver List
                    CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ReadScreen(),
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
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSynopsisContainer() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.0),
          Text(
            'Hannah baru saja menikah dengan Nala. Suaminya itu unggul dalam segala aspek rumah tangga!, inilah kisah pasangan baru nikah.',
            style: TextStyle(
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
