import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> searchAllKomik() async {
    try {
      var Url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Comics);
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
            //set data to prefs
            // prefs?.clear();

            prefs?.setInt('dataKomik[Max]', json['data'].length);
            for (var i = 0; i < json['data'].length; i++) {
              prefs?.setString(
                  'dataKomik[$i][title]', jsonEncode(json['data'][i]['title']));
              prefs?.setString('dataKomik[$i][description]',
                  jsonEncode(json['data'][i]['description']));
              prefs?.setString(
                  'dataKomik[$i][price]', jsonEncode(json['data'][i]['price']));
              String genres = '';
              for (var j = 0; j < json['data'][i]['genres'].length; j++) {
                genres +=
                    json['data'][i]['genres'][j]['name'].toString() + ', ';
              }
              prefs?.setString('dataKomik[$i][genres]', genres);
            }
            // prefs?.setString('dataKomik', jsonEncode(json['data']));
            // print(json['data'][0]['genres'][1]);
            // print(prefs?.getString('dataKomik[0][genres]'));
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
