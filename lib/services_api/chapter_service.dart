import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/model/chapter.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var chapters = <Chapter>[].obs;

  Future<void> getChapters(String comicId) async {
    try {
      isLoading(true);
      hasError(false);
      errorMessage('');

      final SharedPreferences prefs = await _prefs;
      var token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.Comics +
          '/$comicId/chapters');

      http.Response response = await http.get(url, headers: headers);

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        List<dynamic> chapterList = json['data'] ?? [];
        chapters.assignAll(chapterList
            .map((chapterJson) => Chapter.fromJson(chapterJson))
            .toList());
      } else {
        throw Exception(json['message'] ?? 'Unknown error');
      }
    } catch (e) {
      hasError(true);
      errorMessage(e.toString());
    } finally {
      isLoading(false); // Set isLoading to false after API call completes
    }
  }

  Future<void> addChapter({
    required String comicId,
    required String title,
    required String subtitle,
    required List<String> imagePaths,
    required int price,
  }) async {
    try {
      final SharedPreferences prefs = await _prefs;
      var token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.Comics +
          '/$comicId/chapters');

      Map<String, dynamic> requestBody = {
        'title': title,
        'subtitle': subtitle,
        'price': price,
        'images': imagePaths.map((imagePath) => {'image': imagePath}).toList(),
      };

      http.Response response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        Get.showSnackbar(GetSnackBar(
          title: "Sukses",
          message: 'Chapter berhasil ditambahkan',
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          title: "Gagal",
          message: json['message'] ?? 'Unknown error',
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e.toString());
      Get.showSnackbar(GetSnackBar(
        title: "Error",
        message: e.toString(),
        icon: Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> updateChapter({
    required String comicId,
    required String chapterId,
    required String title,
    required String subtitle,
    required List<String> imagePaths,
    required int price,
  }) async {
    try {
      final SharedPreferences prefs = await _prefs;
      var token = prefs.getString('token') ?? '';

      if (token.isEmpty) {
        throw Exception('Token is null or empty');
      }

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(ApiEndPoints.baseUrl + 'chapters/$chapterId/update');

      Map<String, dynamic> requestBody = {
        'title': title,
        'subtitle': subtitle,
        'price': price,
        'images': imagePaths.map((imagePath) => {'image': imagePath}).toList(),
      };

      http.Response response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        Get.showSnackbar(GetSnackBar(
          title: "Sukses",
          message: 'Chapter berhasil diperbarui',
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          title: "Gagal",
          message: json['message'] ?? 'Unknown error',
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e.toString());
      Get.showSnackbar(GetSnackBar(
        title: "Error",
        message: e.toString(),
        icon: Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> deleteChapter({
  required String chapterId,
}) async {
  try {
    final SharedPreferences prefs = await _prefs;
    var token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('Token is null or empty');
    }

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse(ApiEndPoints.baseUrl + 'chapters/$chapterId/delete');


    http.Response response = await http.delete(
      url,
      headers: headers,
    );

    final json = jsonDecode(response.body);

    if (json['status'] == 'success') {
      chapters.removeWhere((chapter) => chapter.id.toString() == chapterId);
      Get.snackbar(
        "Success",
        'Chapter successfully deleted',
        backgroundColor: Colors.green,
      );
    } else {
      Get.snackbar(
        "Error",
        json['message'] ?? 'Unknown error',
        backgroundColor: Colors.red,
      );
    }
  } catch (e) {
    print(e.toString());
    Get.snackbar(
      "Error",
      e.toString(),
      backgroundColor: Colors.red,
    );
  }
}
}