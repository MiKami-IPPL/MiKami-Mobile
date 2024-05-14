import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  TextEditingController searchController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //search komik by title
  Future<void> searchKomik() async {
    try {
      var title = searchController.text;
      var Url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.Comics +
          '?search=$title');
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

        if (json['status'] == 'success') {
          //check data komik max
          if (prefs?.getInt('dataKomik[Max]') != null) {
            var j = prefs?.getInt('dataKomik[Max]');
            for (var i = 0; i < j!; i++) {
              prefs?.remove('dataKomik[$i][title]');
              prefs?.remove('dataKomik[$i][description]');
              prefs?.remove('dataKomik[$i][price]');
              prefs?.remove('dataKomik[$i][genres]');
              prefs?.remove('dataKomik[$i][cover]');
            }
            prefs?.remove('dataKomik[Max]');
          }

          prefs?.setInt('dataKomik[Max]', json['data'].length);
          for (var i = 0; i < json['data'].length; i++) {
            prefs?.setString(
                'dataKomik[$i][title]', (json['data'][i]['title']));
            //set cover
            prefs?.setString(
                'dataKomik[$i][cover]', (json['data'][i]['cover']));
            prefs?.setString('dataKomik[$i][description]',
                jsonEncode(json['data'][i]['description']));
            prefs?.setInt('dataKomik[$i][price]', (json['data'][i]['price']));
            String genres = '';
            for (var j = 0; j < json['data'][i]['genres'].length; j++) {
              genres += json['data'][i]['genres'][j]['name'].toString() + ', ';
            }
            prefs?.setString('dataKomik[$i][genres]', genres);
          }
          print(prefs?.getInt('dataKomik[Max]').toString());
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

  Future<void> searchAllKomik() async {
    try {
      var Url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.Comics +
          '?item=10');
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

        if (json['status'] == 'success') {
          //check data komik max
          if (prefs?.getInt('dataKomik[Max]') != null) {
            var j = prefs?.getInt('dataKomik[Max]');
            for (var i = 0; i < j!; i++) {
              prefs?.remove('dataKomik[$i][title]');
              prefs?.remove('dataKomik[$i][description]');
              prefs?.remove('dataKomik[$i][price]');
              prefs?.remove('dataKomik[$i][genres]');
              prefs?.remove('dataKomik[$i][cover]');
            }
            prefs?.remove('dataKomik[Max]');
          }

          prefs?.setInt('dataKomik[Max]', json['data'].length);
          for (var i = 0; i < json['data'].length; i++) {
            prefs?.setString(
                'dataKomik[$i][title]', (json['data'][i]['title']));
            //set cover
            prefs?.setString(
                'dataKomik[$i][cover]', (json['data'][i]['cover']));
            prefs?.setString('dataKomik[$i][description]',
                jsonEncode(json['data'][i]['description']));
            prefs?.setInt('dataKomik[$i][price]', (json['data'][i]['price']));
            String genres = '';
            for (var j = 0; j < json['data'][i]['genres'].length; j++) {
              genres += json['data'][i]['genres'][j]['name'].toString() + ', ';
            }
            prefs?.setString('dataKomik[$i][genres]', genres);
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

  //get recomended komik
  Future<void> getRecomendedKomik() async {
    try {
      var Url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.Comics +
          '?sortRating=true&item=5');
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

        if (json['status'] == 'success') {
          //check data komik max
          if (prefs?.getInt('dataKomik[Max]') != null) {
            var j = prefs?.getInt('dataKomik[Max]');
            for (var i = 0; i < j!; i++) {
              prefs?.remove('dataKomik[$i][title]');
              prefs?.remove('dataKomik[$i][cover]');
            }
            prefs?.remove('dataKomik[Max]');
          }

          prefs?.setInt('dataKomik[Max]', json['data'].length);
          for (var i = 0; i < json['data'].length; i++) {
            //set cover
            prefs?.setString(
                'dataKomik[$i][cover]', (json['data'][i]['cover']));
            prefs?.setString(
                'dataKomik[$i][title]', (json['data'][i]['title']));
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
