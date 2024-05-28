import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  TextEditingController searchController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> topupCoin(int amount, int perkoin) async {
    try {
      var Url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.TopUpCoins);
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      Map body = {'amount': amount, 'price': perkoin};

      http.Response response =
          await http.post(Url, body: jsonEncode(body), headers: header);
      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        print(json['data'][0]['redirect_url']);
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

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.showSnackbar(GetSnackBar(
        title: 'Location Services Disabled',
        message: 'Location services are disabled. Please enable the services',
        icon: Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: lightColorScheme.error,
      ));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.showSnackbar(GetSnackBar(
          title: 'Location Permissions Denied',
          message: 'Location permissions are denied',
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.error,
        ));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.showSnackbar(GetSnackBar(
        title: 'Location Permissions Denied',
        message:
            'Location permissions are permanently denied, we cannot request permissions.',
        icon: Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: lightColorScheme.error,
      ));
      return false;
    }
    return true;
  }

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
              //id
              prefs?.remove('dataKomik[$i][id]');
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
            //id
            prefs?.setInt('dataKomik[$i][id]', (json['data'][i]['id']));
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
          if (prefs?.getInt('rekKomik[Max]') != null) {
            var j = prefs?.getInt('rekKomik[Max]');
            for (var i = 0; i < j!; i++) {
              prefs?.remove('rekKomik[$i][title]');
              prefs?.remove('rekKomik[$i][cover]');
            }
            prefs?.remove('rekKomik[Max]');
          }

          prefs?.setInt('rekKomik[Max]', json['data'].length);
          for (var i = 0; i < json['data'].length; i++) {
            //set cover
            if (json['data'][i]['cover'] != null) {
              prefs?.setString('rekKomik[$i][cover]', json['data'][i]['cover']);
              prefs?.setString('rekKomik[$i][title]', json['data'][i]['title']);
            } else {
              prefs?.setString('rekKomik[$i][cover]', '');
              prefs?.setString('rekKomik[$i][title]', json['data'][i]['title']);
            }
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

  //post report komik
  Future<void> postReportKomik() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');
      if (token == null) {
        Get.offAll(() => LoginScreen());
      } else {
        var headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var id = prefs?.getInt('selectedID').toString();

        var url = Uri.parse(ApiEndPoints.baseUrl + 'comics/' + id! + '/report');
        print(url);
        Map body = {'reason': reasonController.text};

        http.Response response =
            await http.post(url, body: jsonEncode(body), headers: headers);
        final json = jsonDecode(response.body);

        if (json['status'] == 'success') {
          searchController.clear();
          reasonController.clear();
          prefs?.remove('selectedID');
          prefs?.remove('selectedTitle');
          Get.showSnackbar(GetSnackBar(
            title: "Sukses",
            message: json['message'],
            icon: Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.secondary,
          ));
        } else {
          reasonController.clear();
          prefs?.remove('selectedID');
          prefs?.remove('selectedTitle');
          Get.showSnackbar(GetSnackBar(
            title: json['status'],
            message: json['message'],
            icon: Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.error,
          ));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getRecommendedComics() {}
}
