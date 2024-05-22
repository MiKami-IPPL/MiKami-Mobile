import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mikami_mobile/model/chapter.dart';
import 'package:mikami_mobile/screens/chapter_upload.dart'; // Import your Chapter model

class ChapterManageScreen extends StatefulWidget {
  @override
  _ChapterManageScreenState createState() => _ChapterManageScreenState();
}

class _ChapterManageScreenState extends State<ChapterManageScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late List<Chapter> mockChapters; // Define mockChapters list

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    mockChapters = _loadMockChapters(); // Initialize mockChapters list
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
        onPressed: () => Get.to(ChapterUploadScreen()),
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
          id: 1, title: 'Chapter 1', description: 'Description for Chapter 1'),
      Chapter(
          id: 2, title: 'Chapter 2', description: 'Description for Chapter 2'),
      Chapter(
          id: 3, title: 'Chapter 3', description: 'Description for Chapter 3'),
    ];
  }

  void _deleteChapter(int chapterId) {
    setState(() {
      mockChapters.removeWhere((chapter) => chapter.id == chapterId);
    });
  }

  void _showAddChapterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Chapter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newChapter = Chapter(
                  id: mockChapters.length + 1,
                  title: _titleController.text,
                  description: _descriptionController.text,
                );
                setState(() {
                  mockChapters.add(newChapter);
                });
                _titleController.clear();
                _descriptionController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}