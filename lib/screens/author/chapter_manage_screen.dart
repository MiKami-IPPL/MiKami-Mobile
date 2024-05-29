import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/author/chapter_upload_screen.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterManageScreen extends StatefulWidget {
  const ChapterManageScreen({Key? key}) : super(key: key);

  @override
  _ChapterManageScreenState createState() => _ChapterManageScreenState();
}

class _ChapterManageScreenState extends State<ChapterManageScreen> {
  final AuthorController authorController = Get.put(AuthorController());
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Map<String, String>> chapters = <Map<String, String>>[].obs;

  @override
  void initState() {
    super.initState();
    _loadChaptersFromPrefs();
  }

  Future<void> _loadChaptersFromPrefs() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String>? savedChapters = prefs.getStringList('chapters');
      if (savedChapters != null) {
        chapters.assignAll(savedChapters.map((chapter) {
          final parts = chapter.split('|');
          return {'id': parts[0], 'title': parts[1], 'description': parts[2]};
        }).toList());
      } else {
        chapters.clear();
      }
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Failed to load chapters';
      isLoading.value = false;
    }
  }

  void _navigateToChapterUpload() {
    Get.to(() => ChapterAddScreen());
  }

  void _navigateToChapterUpdate(String chapterId) {
    // Navigate to chapter update screen
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
                // Handle delete action
                authorController.deleteChapter(chapterId);
                Navigator.of(context).pop();
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
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (chapters.isEmpty) {
          return const Center(child: Text('No chapters available'));
        } else {
          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {
              var chapter = chapters[index];
              return ListTile(
                title: Text(chapter['title']!),
                subtitle: Text(chapter['description']!),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToChapterUpdate(chapter['id']!);
                    } else if (value == 'delete') {
                      _showDeleteConfirmationDialog(chapter['id']!);
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
