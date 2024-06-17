import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterUpdateScreen extends StatelessWidget {
  final String chapterId;

  final AuthorController authorController = Get.find();

  ChapterUpdateScreen({Key? key, required this.chapterId}) : super(key: key);

  final List<XFile> selectedImages = [];

  void setSelectedImages(List<XFile> images) {
    selectedImages.clear();
    selectedImages.addAll(images);
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      List<String> imagePaths = images.map((image) => image.path).toList();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('images', imagePaths);
      setSelectedImages(images); // Update selectedImages
      print(imagePaths);
    }
  }

  Future<void> submitChapter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('images') != null) {
      final title = authorController.titleController.text;
      print("Title: $title");
      if (title.isNotEmpty) {
        print("Submitting chapter update...");
        await authorController.updateChapter(chapterId); // Use the controller to update the chapter
      } else {
        Get.snackbar(
          'Error',
          'Title field is required',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        'Please pick images first',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Chapter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title field
              TextFormField(
                controller: authorController.titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter chapter title',
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle field
              TextFormField(
                controller: authorController.subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  hintText: 'Enter chapter subtitle',
                ),
              ),
              const SizedBox(height: 16),

              // Price field
              TextFormField(
                controller: authorController.priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter chapter price',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Image picker button
              ElevatedButton(
                onPressed: pickImages,
                child: const Text('Pick Images'),
              ),
              const SizedBox(height: 16),

              // Display selected images
              if (selectedImages.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: selectedImages
                      .map((image) => Image.file(
                            File(image.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ))
                      .toList(),
                ),

              const SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: submitChapter, // Call the submitChapter method
                child: const Text('Submit Chapter'), // Change the button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
