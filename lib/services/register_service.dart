import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';

class RegisterController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController age = TextEditingController();

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
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'success') {
          name.clear();
          email.clear();
          password.clear();
          age.clear();
          Get.off(LoginScreen());
          Get.showSnackbar(GetSnackBar(
            title: "Sukses",
            message: 'Registrasi berhasil, silahkan login',
            icon: Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.secondary,
          ));
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
