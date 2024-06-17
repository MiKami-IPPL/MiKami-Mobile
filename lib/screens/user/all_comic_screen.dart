import 'package:flutter/material.dart';
import 'package:mikami_mobile/screens/comic_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart'; 

class AllComicsScreen extends StatefulWidget {
  const AllComicsScreen({Key? key}) : super(key: key);

  @override
  State<AllComicsScreen> createState() => _AllComicsScreenState();
}

class _AllComicsScreenState extends State<AllComicsScreen> {
  late Future<SharedPreferences> _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Comics'),
        backgroundColor: Colors.yellow[600],
      ),
      body: FutureBuilder(
        future: _prefs,
        builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final SharedPreferences prefs = snapshot.data!;
            final int? max = prefs.getInt('dataKomik[Max]');
            final List<Map<String, dynamic>> comics = [];
            
            if (max != null && max > 0) {
              for (int i = 0; i < max; i++) {
                final int? id = prefs.getInt('dataKomik[$i][id]');
                final String? title = prefs.getString('dataKomik[$i][title]');
                final String? cover = prefs.getString('dataKomik[$i][cover]');
                final String? description = prefs.getString('dataKomik[$i][description]');
                if (id != null && title != null && cover != null && description != null) {
                  comics.add({'id': id, 'title': title, 'cover': cover, 'description': description});
                }
              }
            }
            return comics.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ComicsGridView(comics: comics),
                  )
                : Center(child: Text('No comics found'));
          }
        },
      ),
    );
  }
}

class ComicsGridView extends StatelessWidget {
  final List<Map<String, dynamic>> comics;

  const ComicsGridView({required this.comics});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: comics.length,
      itemBuilder: (context, index) {
        var comic = comics[index];
        return Padding(
          padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
          child: RoundedImageWithText(
            imagePath: comic['cover'],
            text: comic['title'],
            onTap: () {
              Get.to(() => ComicDetail(
                id: comic['id'],
                // Pass the comic details to ComicDetailScreen
                title: comic['title'],
                description: comic['description'],
                cover: comic['cover'],
              ));
            },
          ),
        );
      },
    );
  }
}

class RoundedImageWithText extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback onTap;

  const RoundedImageWithText({
    required this.imagePath,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imagePath,
              height: 120,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Container(
            width: 100,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
