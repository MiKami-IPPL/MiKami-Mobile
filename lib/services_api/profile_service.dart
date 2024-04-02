import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var Url =
      Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Profile);
  Future<void> logout() async {
    final SharedPreferences? prefs = await _prefs;
    await prefs?.remove('token');
    Get.offAll(() => LoginScreen());
  }

  Future<void> changePassword() async {
    Get.toNamed('/change-password');
  }

  Future<void> getProfile() async {
    final SharedPreferences? prefs = await _prefs;
    var token = prefs?.getString('token');
    if (token == null) {
      Get.offAll(() => LoginScreen());
    } else {
      //get data nama profile
      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response = await http.get(Url, headers: header);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'success') {
          print(json['data']);
          prefs?.setString('name', json['data']['name']);
          prefs?.setString('email', json['data']['email']);
          prefs?.setString('role', json['data']['role']);
          prefs?.setInt('age', json['data']['age']);
          prefs?.setInt('remainingAds', json['data']['remainingAds']);
        } else {
          Get.showSnackbar(GetSnackBar(
            title: json['status'],
            message: json['message'],
            icon: Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.error,
          ));
        }
      } else {
        Get.showSnackbar(GetSnackBar(
          title: 'Error',
          message: 'Terjadi kesalahan',
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.error,
        ));
      }
    }
  }
}
