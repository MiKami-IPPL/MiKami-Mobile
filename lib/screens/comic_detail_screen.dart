import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/read_screen.dart'; // Import if necessary
import 'package:mikami_mobile/services_api/controller/user_service.dart'; // Import UserService if necessary
import 'package:mikami_mobile/services_api/controller/profile_service.dart'; // Import ProfileService if necessary

class ComicDetail extends StatefulWidget {
  final int id;
  final String title; // New: title
  final String description; // New: description
  final String cover; // New: cover

  const ComicDetail({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.cover,
  }) : super(key: key);

  @override
  _ComicDetailState createState() => _ComicDetailState();
}

class _ComicDetailState extends State<ComicDetail> {
  late Future<SharedPreferences> _prefs;
  late Future<void> _comicDetailFuture;
  List<Map<String, dynamic>> _chapters = [];
  int _userCoins = 0;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferences.getInstance();
    _comicDetailFuture = _fetchComicDetails();
    _fetchUserCoins();
  }

  Future<void> _fetchComicDetails() async {
    final UserController userController = Get.put(UserController());

    // Panggil getChapters untuk mendapatkan daftar bab beserta harga
    await userController.getChapters(widget.id);

    // Dapatkan daftar bab setelah diambil dari getChapters
    final SharedPreferences prefs = await _prefs;
    final List<String>? chaptersList = prefs.getStringList('chapters');
    if (chaptersList != null) {
      setState(() {
        _chapters = chaptersList.map((chapterData) {
          final chapterParts = chapterData.split('|');
          return {
            'id': int.parse(chapterParts[0]),
            'title': chapterParts[1],
            'subtitle': chapterParts[2],
            'price': chapterParts[3],
            'purchased': chapterParts[4] == 'true',
          };
        }).toList();
      });
    }
  }

  Future<void> _fetchUserCoins() async {
    final ProfileController profileService = Get.put(ProfileController());
    await profileService.getCoin();
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _userCoins = prefs.getInt('coin') ?? 0;
    });
  }

  void _showPurchaseDialog(Map<String, dynamic> chapter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Purchase Chapter'),
          content: Text(
            'You have $_userCoins coins. Do you want to purchase "${chapter['title']}" for ${chapter['price']} coins?',
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Purchase'),
              onPressed: () async {
                Navigator.of(context).pop();
                // Ensure that chapter['price'] is an integer
                int chapterPrice = int.parse(chapter['price'].toString());
                if (_userCoins >= chapterPrice) {
                  setState(() {
                    chapter['purchased'] = true;
                    _userCoins -= chapterPrice;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setInt('coin', _userCoins);

                  await prefs.setInt('comic_id', widget.id);
                  await prefs.setInt('chapter_id', chapter['id']);
                  await prefs.setString(
                      'chapter_title', chapter['title']); // Store chapter title

                  // Call the chapterPurchase method
                  await UserController().chapterPurchase(chapter['id']);

                  Get.to(() => const ReadScreen());
                } else {
                  Get.showSnackbar(GetSnackBar(
                    title: 'Error',
                    message: 'Insufficient coins',
                    icon: Icon(Icons.error, color: Colors.white),
                    duration: const Duration(seconds: 5),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onChapterTap(Map<String, dynamic> chapter) async {
    if (chapter['purchased']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('comic_id', widget.id);
      await prefs.setInt('chapter_id', chapter['id']);
      await prefs.setString(
          'chapter_title', chapter['title']); // Store chapter title
      Get.to(() => const ReadScreen());
    } else {
      _showPurchaseDialog(chapter);
    }
  }

  void _showRatingDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      int _rating = 0;
      return AlertDialog(
        title: Text('Rate Comic'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                  ),
                  color: Colors.amber,
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            );
          },
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              Navigator.of(context).pop();
              Get.showSnackbar(GetSnackBar(
                title: 'Thank you!',
                message: 'You rated this comic $_rating stars.',
                icon: Icon(Icons.star, color: Colors.white),
                duration: const Duration(seconds: 5),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
              ));
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _comicDetailFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return FutureBuilder<SharedPreferences>(
            future: _prefs,
            builder: (BuildContext context,
                AsyncSnapshot<SharedPreferences> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final SharedPreferences prefs = snapshot.data!;
                final String cover =
                    widget.cover; // Use the received cover as background
                final String description =
                    widget.description; // Use the received description

                return Scaffold(
                  body: DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            backgroundColor: Colors.amber[300],
                            iconTheme: const IconThemeData(color: Colors.white),
                            pinned: true,
                            floating: true,
                            expandedHeight: 250,
                            flexibleSpace: FlexibleSpaceBar(
                              title: Text(
                                widget.title, // Gunakan judul komik di sini
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              background: cover.isNotEmpty
                                  ? Image.network(
                                      cover,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey,
                                        );
                                      },
                                    )
                                  : Container(color: Colors.grey),
                            ),
                            actions: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.favorite),
                                color: Colors.white,
                                onPressed: () {
                                  // do something
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.star),
                                color: Colors.white,
                                onPressed: () {
                                  _showRatingDialog();
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
                          ),
                          SliverPersistentHeader(
                            delegate: _SliverAppBarDelegate(
                              const TabBar(
                                indicatorColor: Colors.red,
                                tabs: [
                                  Tab(text: 'Synopsis'),
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
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildSynopsisContainer(description),
                                // Add your preview images here
                              ],
                            ),
                          ),
                          CustomScrollView(
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final chapter = _chapters[index];
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _onChapterTap(chapter),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                title:
                                                    Text('${chapter['title']}'),
                                                subtitle:
                                                    Text(chapter['subtitle']),
                                                trailing: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      'Price: ${chapter['price']}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      chapter['purchased']
                                                          ? 'Purchased'
                                                          : 'Not Purchased',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            chapter['purchased']
                                                                ? Colors.blue
                                                                : Colors.red,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  childCount: _chapters.length,
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
      },
    );
  }

  Widget _buildSynopsisContainer(String description) {
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
      child: Text(
        description,
        style: TextStyle(
          fontSize: 13.0,
        ),
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
