import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikami_mobile/services_api/chapter_service.dart';

class ChapterAddScreen extends StatelessWidget {
  final ChapterController _chapterService = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final int comicId;

  ChapterAddScreen({required this.comicId});

  final List<XFile> selectedImages = [];

  void setSelectedImages(List<XFile> images) {
    selectedImages.clear();
    selectedImages.addAll(images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Chapter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form fields
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter chapter title',
                ),
              ),
              SizedBox(height: 16), // Add space between form fields
              TextFormField(
                controller: subtitleController,
                decoration: InputDecoration(
                  labelText: 'Subtitle',
                  hintText: 'Enter chapter subtitle',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter chapter price',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              // Image picker
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final List<XFile>? images = await picker.pickMultiImage();
                  if (images != null) {
                    setSelectedImages(images);
                  }
                },
                child: Text('Pick Images'),
              ),
              SizedBox(height: 16), // Add space between button and form fields

              // Submit button
              ElevatedButton(
                onPressed: () async {
                  // Convert price to integer
                  int price = int.tryParse(priceController.text) ?? 0;
                  List<String> imagePaths = selectedImages.map((image) => image.path).toList();
                  await _chapterService.addChapter(
                    comicId: comicId.toString(),
                    title: titleController.text,
                    subtitle: subtitleController.text,
                    imagePaths: imagePaths,
                    price: price, 
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
