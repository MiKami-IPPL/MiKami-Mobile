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
    await prefs?.clear();
    Get.offAll(() => LoginScreen());
  }

  Future<void> changePassword() async {
    Get.toNamed('/change-password');
  }

  Future<void> getProfile() async {
    try {
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

        final json = jsonDecode(response.body);
        if (response.statusCode == 200) {
          if (json['status'] == 'success') {
            print(json['data']);
            await prefs?.setString('name', json['data']['name']);
            await prefs?.setString('email', json['data']['email']);
            await prefs?.setString('role', json['data']['role']);
            await prefs?.setInt('age', json['data']['age']);
            await prefs?.setInt('remainingAds', json['data']['remainingAds']);
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
            title: json['status'],
            message: json['message'],
            icon: Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.error,
          ));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
