import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mikami_mobile/model/chapter.dart';
import 'package:mikami_mobile/model/comic.dart';
import 'package:mikami_mobile/screens/chapter_upload.dart';
import 'package:mikami_mobile/services_api/chapter_service.dart';

class ChapterManageScreen extends StatefulWidget {
  final Comic? comic;

  const ChapterManageScreen({Key? key, this.comic}) : super(key: key);

  @override
  _ChapterManageScreenState createState() => _ChapterManageScreenState();
}

class _ChapterManageScreenState extends State<ChapterManageScreen> {
  late List<Chapter> mockChapters;

  @override
  void initState() {
    super.initState();
    mockChapters = _loadMockChapters();
    Get.put(ChapterController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.amber[300],
        title: Text('Chapter Management'),
      ),
      body: ListView.builder(
        itemCount: mockChapters.length,
        itemBuilder: (context, index) {
          final chapter = mockChapters[index];
          return ListTile(
            title: Text(chapter.title),
            subtitle: Text(chapter.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteChapter(chapter.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(ChapterAddScreen(comicId: widget.comic!.id)),
        shape: const StadiumBorder(),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Function to load mock chapters
  List<Chapter> _loadMockChapters() {
    return [
      Chapter(
          id: 1, title: 'Chapter 1', description: 'Description for Chapter 1', price: 0),
      Chapter(
          id: 2, title: 'Chapter 2', description: 'Description for Chapter 2', price: 0),
      Chapter(
          id: 3, title: 'Chapter 3', description: 'Description for Chapter 3', price: 0),
    ];
  }

  void _deleteChapter(int chapterId) {
    setState(() {
      mockChapters.removeWhere((chapter) => chapter.id == chapterId);
    });
  }
}
