import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Login);

      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print(json['status']);
        if (json['status'] == 'success') {
          emailController.clear();
          passwordController.clear();
          var token = json['data']['token'];
          print(token);
          final SharedPreferences? prefs = await _prefs;
          await prefs?.setString('token', token);
          print("berhasil login");
        } else {
          print(json['status'] + json['message']);
        }
      } else {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan saat login',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
