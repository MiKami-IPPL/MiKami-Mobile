import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/screens/user/home_screen.dart';
import 'package:mikami_mobile/services_api/controller/profile_service.dart';
import 'package:mikami_mobile/services_api/controller/user_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxService {
  //for login
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //for forgot password
  TextEditingController emailForgotController = TextEditingController();
  //for registration
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController age = TextEditingController();

  ProfileController profilecontroller = Get.put(ProfileController());
  UserController usercontroller = Get.put(UserController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> isLogin() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');
      if (token == null) {
        prefs?.clear();
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> forgotPassword() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.ForgotPassword);

      Map body = {
        'email': emailForgotController.text.trim(),
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        emailForgotController.clear();
        Get.showSnackbar(GetSnackBar(
          title: "Sukses",
          message: json['message'],
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.secondary,
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          title: json['status'],
          message: json['message'],
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.error,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loginTamuLoading() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Login);

      Map body = {
        'email': 'tamu@mikami.com',
        'password': 'tamu',
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        final SharedPreferences? prefs = await _prefs;
        prefs?.clear();
        prefs?.setString('token', json['data']['token']);
        prefs?.setString('password', 'tamu');
        emailController.clear();
        passwordController.clear();
        Get.offAll(() => HomeScreen());

        await profilecontroller.getProfile();
        Get.showSnackbar(GetSnackBar(
          title: "Sukses",
          message: 'Login berhasil',
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.secondary,
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          title: json['status'],
          message: json['message'],
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.error,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loginWithEmail() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };

      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Login);

      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        final SharedPreferences? prefs = await _prefs;
        prefs?.clear();
        prefs?.setString('token', json['data']['token']);
        prefs?.setString('password', passwordController.text);
        emailController.clear();
        passwordController.clear();
        Get.offAll(() => HomeScreen());
        await profilecontroller.getProfile();
        Get.showSnackbar(GetSnackBar(
          title: "Sukses",
          message: 'Login berhasil',
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.secondary,
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          title: json['status'],
          message: json['message'],
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.error,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //make getsnack to show loading when login
  Future<void> login() async {
    Get.showSnackbar(GetSnackBar(
      title: "Loading",
      message: 'Please wait...',
      icon: Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
      backgroundColor: lightColorScheme.secondary,
    ));
    await loginWithEmail();
  }

  //make getsnack to show loading when tamu login
  Future<void> loginTamu() async {
    Get.showSnackbar(GetSnackBar(
      title: "Loading",
      message: 'Please wait...',
      icon: Icon(Icons.check_circle, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
      backgroundColor: lightColorScheme.secondary,
    ));
    await loginTamuLoading();
  }

  Future<void> registerWithEmail() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Register);
      Map body = {
        'name': name.text,
        'email': email.text.trim(),
        'password': password.text,
        'age': age.text,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

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
        Get.showSnackbar(GetSnackBar(
          title: json['status'],
          message: json['message'],
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
