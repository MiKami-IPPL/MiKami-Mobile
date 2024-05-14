import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/model/chapter.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChapterController extends GetxService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  Future<void> getChapters(String comicId) async {
    try {
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Comics + '/$comicId/chapters' );


      http.Response response = await http.get(url, headers: headers);

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        
      } else {
        // Handle error response
      }
    } catch (e) {
      print(e.toString());
      // Handle error
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
    final SharedPreferences? prefs = await _prefs;
    var token = prefs?.getString('token');

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Comics + '/$comicId/chapters' );

    print(url);

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
      // Handle successful response
      Get.showSnackbar(GetSnackBar(
        title: "Sukses",
        message: 'Chapter berhasil ditambahkan',
        icon: Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      ));
    } else {
      // Handle error response
      Get.showSnackbar(GetSnackBar(
        title: "Gagal",
        message: json['message'],
        icon: Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));
    }
  } catch (e) {
    print(e.toString());
    // Handle error
  }
}

  Future<void> updateChapter({
    required String comicId,
    required String chapterId,
    required String title,
    required String subtitle,
    required List<String> imagePaths,
  }) async {
    try {
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse('${ApiEndPoints.baseUrl}/api/comics/$comicId/chapters/$chapterId/update');

      Map<String, dynamic> requestBody = {
        'title': title,
        'subtitle': subtitle,
        'images': imagePaths.map((imagePath) => {'image': imagePath}).toList(),
      };

      http.Response response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        // Handle successful response
      } else {
        // Handle error response
      }
    } catch (e) {
      print(e.toString());
      // Handle error
    }
  }

  Future<void> deleteChapter({
    required String comicId,
    required String chapterId,
  }) async {
    try {
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse('${ApiEndPoints.baseUrl}/api/comics/$comicId/chapters/$chapterId/delete');

      http.Response response = await http.delete(
        url,
        headers: headers,
      );

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        // Handle successful response
      } else {
        // Handle error response
      }
    } catch (e) {
      print(e.toString());
      // Handle error
    }
  }

  // Add other methods as needed
}
