import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/author_home_screen.dart';
import 'package:mikami_mobile/screens/main_menu.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxService {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> loginWithEmail() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.loginEmail);

      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (json['status'] == 'success') {
          // emailController.clear();
          // passwordController.clear();
          var token = json['data']['token'];
          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString('token', token);
          Get.off(() => AuthorScreen());
          Get.showSnackbar(GetSnackBar(
            title: "Sukses",
            message: 'Login berhasil',
            icon: Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.secondary,
          ));
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
    } catch (e) {
      print(e.toString());
    }
  }
}
