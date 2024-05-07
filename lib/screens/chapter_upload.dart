import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/services_api/chapter_upload_controller.dart';
import 'package:image_picker/image_picker.dart';

class ChapterUploadScreen extends StatefulWidget {
  @override
  _ChapterUploadScreenState createState() => _ChapterUploadScreenState();
}

class _ChapterUploadScreenState extends State<ChapterUploadScreen> {
  final ChapterUploadController chapterUploadController =
      Get.put(ChapterUploadController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Chapter'),
        backgroundColor: Colors.amber[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: chapterUploadController.title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: chapterUploadController.subtitle,
                decoration: InputDecoration(labelText: 'Subtitle'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a subtitle' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Select Images'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    chapterUploadController.uploadChapter();
                  }
                },
                child: Text('Upload Chapter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await ImagePicker().pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 80,
      );

      if (images != null) {
        List<File> imageFiles = images.map((image) => File(image.path)).toList();
        chapterUploadController.setSelectedImages(imageFiles);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }


}
