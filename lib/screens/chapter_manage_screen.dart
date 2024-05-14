import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/model/comic.dart';
import 'package:mikami_mobile/model/chapter.dart';
import 'package:mikami_mobile/screens/chapter_upload.dart';
import 'package:mikami_mobile/services_api/chapter_service.dart';
import 'package:mikami_mobile/screens/chapter_update_screen.dart';

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
    if (widget.comic != null) {
      _chapterController.getChapters(widget.comic!.id.toString());
    }
  }

  void _navigateToChapterUpload() {
    Get.to(() => ChapterAddScreen(
          comicId: widget.comic!.id,
        ));
  }

  void _navigateToChapterUpdate(String chapterId) {
    Get.to(() => ChapterUpdateScreen(
          comicId: widget.comic!.id,
          chapterId: chapterId,
        ));
  }

  void _showDeleteConfirmationDialog(String chapterId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this chapter?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog before deletion
                _chapterController.deleteChapter(
                  chapterId: chapterId,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter Management'),
      ),
      body: Obx(() {
        if (_chapterController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (_chapterController.hasError.value) {
          return Center(
            child: Text(
              _chapterController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (_chapterController.chapters.isEmpty) {
          return const Center(child: Text('No chapters available'));
        } else {
          return ListView.builder(
            itemCount: _chapterController.chapters.length,
            itemBuilder: (context, index) {
              var chapter = _chapterController.chapters[index];
              return ListTile(
                title: Text(chapter.title),
                subtitle: Text(chapter.description),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToChapterUpdate(chapter.id.toString());
                    } else if (value == 'delete') {
                      _showDeleteConfirmationDialog(chapter.id.toString());
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToChapterUpload,
        child: const Icon(Icons.add),
      ),
    );
  }
}
