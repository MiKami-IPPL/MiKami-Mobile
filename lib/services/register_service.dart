import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController age = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> registerWithEmail() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.registerEmail);
      Map body = {
        'name': name.text,
        'email': email.text.trim(),
        'password': password.text,
        'age': age.text,
      };
      // print(body);
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        print(json['status']);
        if (json['status'] == 'success') {
          name.clear();
          email.clear();
          password.clear();
          age.clear();
          print("berhasil mendaftar");
        } else {
          print(json['status'] + json['message']);
        }
      } else {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan saat mendaftar',
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
