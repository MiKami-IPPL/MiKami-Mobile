import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/services_api/chapter_upload_service.dart';

class ChapterUploadController extends GetxController {
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();

  final ChapterUploadService _chapterUploadService = ChapterUploadService();

  List<File> selectedImages = <File>[];

  void setSelectedImages(List<File> images) {
    selectedImages = images;
    update(); // Notify listeners of the change
  }

  Future<void> uploadChapter() async {
    try {
      // Get list of image paths from selected images
      List<String> imagePaths = [];
      for (File image in selectedImages) {
        // Simulate image upload and get image URL/path
        String imageUrl = await _uploadImage(image);
        imagePaths.add(imageUrl);
      }

      // Call the ChapterUploadService to upload chapter with title, subtitle, and image paths
      bool success = await _chapterUploadService.uploadChapter(
        title: title.text,
        subtitle: subtitle.text,
        imagePaths: imagePaths,
      );

      if (success) {
        // Show success snackbar and clear text controllers
        Get.snackbar(
          'Success',
          'Chapter uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        title.clear();
        subtitle.clear();
        selectedImages.clear(); // Clear selected images after upload
      } else {
        // Show error snackbar
        Get.snackbar(
          'Error',
          'Failed to upload chapter',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Handle any error that may occur during upload
      print('Error uploading chapter: $e');
      Get.snackbar(
        'Error',
        'An error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    // Simulate image upload logic and return image URL/path
    await Future.delayed(Duration(seconds: 2)); // Simulate delay
    return 'https://example.com/uploaded-image.jpg'; // Replace with actual image URL
  }

  @override
  void onClose() {
    // Clean up controllers when the controller is disposed
    title.dispose();
    subtitle.dispose();
    super.onClose();
  }
}