import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterAddScreen extends StatelessWidget {
  final AuthorController authorcontroller = Get.put(AuthorController());

  ChapterAddScreen({Key? key}) : super(key: key);

  final List<XFile> selectedImages = [];

  void setSelectedImages(List<XFile> images) {
    selectedImages.clear();
    selectedImages.addAll(images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Chapter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title field
              TextFormField(
                controller: authorcontroller.titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter chapter title',
                ),
              ),
              const SizedBox(height: 16),

              // Subtitle field
              TextFormField(
                controller: authorcontroller.subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  hintText: 'Enter chapter subtitle',
                ),
              ),
              const SizedBox(height: 16),

              // Price field
              TextFormField(
                controller: authorcontroller.priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter chapter price',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Image picker button
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final List<XFile>? images = await picker.pickMultiImage();
                  if (images != null) {
                    List<String> imagePaths =
                        images.map((image) => image.path).toList();
                    // insert imagePaths into prefs
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setStringList('images', imagePaths);
                    print(imagePaths);
                  }
                },
                child: const Text('Pick Images'),
              ),
              const SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  if (prefs.getStringList('images') != null) {
                    await authorcontroller.uploadChapter();
                  } else {
                    Get.snackbar(
                      'Error',
                      'Please pick images first',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
