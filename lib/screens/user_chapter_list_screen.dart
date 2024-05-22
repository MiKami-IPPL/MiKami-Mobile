import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/model/comic.dart';
import 'package:mikami_mobile/services_api/controller/chapter_service.dart';

class ChapterListScreen extends StatelessWidget {
  final Comic comic;
  final ChapterController _chapterController = Get.put(ChapterController());

  ChapterListScreen({required this.comic});

  @override
  Widget build(BuildContext context) {
    _chapterController.getChapters(comic.id.toString()); // Fetch chapters when the screen is built

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
        title: Text('Chapters of ${comic.title}'),
      ),
      body: Obx(() {
        if (_chapterController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_chapterController.hasError.value) {
          return Center(child: Text('Error loading chapters: ${_chapterController.errorMessage.value}'));
        } else if (_chapterController.chapters.isEmpty) {
          return Center(child: Text('No chapters available'));
        } else {
          return ListView.builder(
            itemCount: _chapterController.chapters.length,
            itemBuilder: (context, index) {
              var chapter = _chapterController.chapters[index];
              return ListTile(
                title: Text(chapter.title),
                subtitle: Text('Chapter ${chapter.description}'),
                onTap: () {
                  // Implement chapter read functionality here
                },
              );
            },
          );
        }
      }),
    );
  }
}
