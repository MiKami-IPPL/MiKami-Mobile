import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikami_mobile/services_api/chapter_service.dart';
import 'package:mikami_mobile/model/chapter.dart';

class ChapterUpdateScreen extends StatelessWidget {
  final ChapterController _chapterService = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final int comicId;
  final String chapterId;

  ChapterUpdateScreen({required this.comicId, required this.chapterId});

  final List<XFile> selectedImages = [];

  void setSelectedImages(List<XFile> images) {
    selectedImages.clear();
    selectedImages.addAll(images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Chapter'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            if (_chapterService.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else if (_chapterService.hasError.value) {
              return Center(
                child: Text(
                  _chapterService.errorMessage.value,
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
        
              final chapter = _chapterService.chapters.firstWhere(
                (chapter) => chapter.id == int.parse(chapterId),
                orElse: () => Chapter(id: 0, title: '', description: '', price: 0), 
              );

              titleController.text = chapter.title;
              subtitleController.text = chapter.description;
              priceController.text = chapter.price.toString();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter chapter title',
                    ),
                  ),
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      int price = int.tryParse(priceController.text) ?? 0;
                      List<String> imagePaths = selectedImages.map((image) => image.path).toList();
                      await _chapterService.updateChapter(
                        comicId: comicId.toString(),
                        chapterId: chapterId,
                        title: titleController.text,
                        subtitle: subtitleController.text,
                        imagePaths: imagePaths,
                        price: price,
                      );
                    },
                    child: Text('Update'),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
