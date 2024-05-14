import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  late ChapterController _chapterController;

  @override
  void initState() {
    super.initState();
    _chapterController = Get.put(ChapterController());
    _loadChapters();
  }

  void _loadChapters() async {
    await _chapterController.getChapters(widget.comic!.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Kelola Chapter',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.amber[300],
      ),
      body: Obx(() {
        if (_chapterController.hasError.value) {
          return Center(child: Text(_chapterController.errorMessage.value));
        } else if (_chapterController.chapters.isEmpty) {
          return Center(child: Text('No chapters available'));
        } else {
          return ListView.builder(
            itemCount: _chapterController.chapters.length,
            itemBuilder: (context, index) {
              final chapter = _chapterController.chapters[index];
              return Column(
                children: [
                  ListTile(
                    title: Text(chapter.title ?? 'No title'),
                    subtitle: Text(chapter.description ?? 'No description'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteChapter(chapter.id.toString());
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {
                            
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                ],
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ChapterAddScreen(comicId: widget.comic!.id!));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _deleteChapter(String chapterId) async {
    // Implement delete chapter logic here
  }
}
