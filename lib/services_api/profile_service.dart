import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/welcome_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> logout() async {
    final SharedPreferences? prefs = await _prefs;
    if (prefs?.getString('name') == 'tamu') {
      prefs?.clear();
      Get.offAll(() => WelcomeScreen());
    } else {
      //show dialog
      Get.defaultDialog(
        title: 'Logout',
        middleText: 'Are you sure want to logout?',
        textConfirm: 'Yes',
        textCancel: 'No',
        confirmTextColor: Colors.white,
        buttonColor: lightColorScheme.primary,
        onConfirm: () async {
          prefs?.clear();
          Get.offAll(() => WelcomeScreen());
        },
      );
    }
  }

  Future<void> changePassword() async {
    Get.toNamed('/change-password');
  }

  Future<void> getCoin() async {
    try {
      var Url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Coins);
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response = await http.get(Url, headers: header);

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        if (json['data'][0]['amount'] == null) {
          prefs?.setInt('coin', 0);
        } else {
          prefs?.setInt('coin', json['data'][0]['amount']);
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

  Future<void> getProfile() async {
    try {
      var Url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Profile);
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      //get data nama profile
      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response = await http.get(Url, headers: header);

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        prefs?.setString('name', json['data']['name']);
        prefs?.setString('email', json['data']['email']);
        prefs?.setString('role', json['data']['role']);
        prefs?.setInt('age', json['data']['age']);
        prefs?.setInt('remainingAds', json['data']['remainingAds']);
        await getCoin();
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
