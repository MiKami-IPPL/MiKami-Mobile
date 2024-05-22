import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/model/comic.dart';
import 'package:mikami_mobile/services_api/comic_service.dart';
import 'package:mikami_mobile/screens/user_chapter_list_screen.dart';

class ComicListScreen extends StatelessWidget {
  final ComicController comicController = Get.put(ComicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[300],
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.amber[300],
        title: const Text('Comic List'),
      ),
      body: Obx(() {
        if (comicController.comics.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.amber[300],
                  padding: const EdgeInsets.all(16.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comic List',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: comicController.comics.length,
                      itemBuilder: (context, index) {
                        Comic comic = comicController.comics[index];
                        return Column(
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              leading: Container(
                                width: 70,
                                height: 70,
                                color: Colors.blue,
                                child: _buildCoverImage(comic.coverUrl),
                              ),
                              title: Text(
                                comic.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: ListTileSubtitle(
                                line1: comic.description,
                                line2: 'Author: ${comic.author}\nRate: ${comic.rate}',
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (String choice) {
                                  if (choice == 'Read Comic') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChapterListScreen(comic: comic),
                                      ),
                                    );
                                  } else if (choice == 'Add to Favorite') {
                                    // Implement add to favorite functionality
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'Read Comic',
                                    child: Text('Read Comic'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'Add to Favorite',
                                    child: Text('Add to Favorite'),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildCoverImage(String coverUrl) {
    return Image.network(
      coverUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/images/hannahBanner.jpg', fit: BoxFit.cover);
      },
    );
  }
}

class ListTileSubtitle extends StatelessWidget {
  final String line1;
  final String line2;

  const ListTileSubtitle({required this.line1, required this.line2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
        Text(
          line2,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
