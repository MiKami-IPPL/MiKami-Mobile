import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/screens/user/payment_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  TextEditingController searchController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> getTopupHistory() async {
    try {
      var Url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.TopupHistory);
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');
      if (token == null) {
        Get.offAll(() => LoginScreen());
      } else {
        var header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        http.Response response = await http.get(Url, headers: header);
        final json = jsonDecode(response.body);
        print(json);

        if (json['status'] == 'success') {
          if (prefs?.getInt('topupHistory[Max]') != null) {
            var j = prefs?.getInt('topupHistory[Max]');
            for (var i = 0; i < j!; i++) {
              prefs?.remove('topupHistory[$i][order_id]');
              prefs?.remove('topupHistory[$i][price]');
              prefs?.remove('topupHistory[$i][status]');
              prefs?.remove('topupHistory[$i][created_at]');
              prefs?.remove('topupHistory[$i][updated_at]');
            }
            prefs?.remove('topupHistory[Max]');
          }

          prefs?.setInt('topupHistory[Max]', json['data'].length);
          for (var i = 0; i < json['data'].length; i++) {
            prefs?.setString(
                'topupHistory[$i][id]', json['data'][i]['order_id']);
            prefs?.setInt('topupHistory[$i][price]', json['data'][i]['price']);
            prefs?.setString(
                'topupHistory[$i][status]', json['data'][i]['status']);
            prefs?.setString(
                'topupHistory[$i][created_at]', json['data'][i]['created_at']);
            prefs?.setString(
                'topupHistory[$i][updated_at]', json['data'][i]['updated_at']);
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
      Map body = {'coin_amount': amount, 'price': perkoin};

      http.Response response =
          await http.post(Url, body: jsonEncode(body), headers: header);
      final json = jsonDecode(response.body);
      print(json);

      if (json['message'] == 'success') {
        await Get.to(
            () => PaymentScreen(linkPayment: json['data']['redirect_url']));
        // await profilecontroller.getCoin();
      } else {
        Get.showSnackbar(GetSnackBar(
          title: 'Error',
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
              prefs?.setInt('rekKomik[$i][id]', json['data'][i]['id']);
              prefs?.setString(
                  'rekKomik[$i][description]', json['data'][i]['description']);
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

  Future<void> fetchAndStoreAllComics() async {
    try {
      var Url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Comics);
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');
      if (token == null) {
        Get.offAll(() => LoginScreen());
        return;
      } else {
        var header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        http.Response response = await http.get(Url, headers: header);
        final json = jsonDecode(response.body);

        if (json['status'] == 'success') {
          // Clear old comics data
          if (prefs?.getInt('dataKomik[Max]') != null) {
            var j = prefs?.getInt('dataKomik[Max]');
            for (var i = 0; i < j!; i++) {
              prefs?.remove('dataKomik[$i][id]');
              prefs?.remove('dataKomik[$i][title]');
              prefs?.remove('dataKomik[$i][cover]');
            }
            prefs?.remove('dataKomik[Max]');
          }

          // Store new comics data
          prefs?.setInt('dataKomik[Max]', json['data'].length);
          for (var i = 0; i < json['data'].length; i++) {
            prefs?.setInt('dataKomik[$i][id]', json['data'][i]['id']);
            prefs?.setString('dataKomik[$i][title]', json['data'][i]['title']);
            prefs?.setString('dataKomik[$i][cover]', json['data'][i]['cover']);
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

  Future<List<Map<String, dynamic>>> loadAllComicsFromPrefs() async {
    final SharedPreferences prefs = await _prefs;
    var max = prefs.getInt('dataKomik[Max]') ?? 0;
    var comics = <Map<String, dynamic>>[];

    for (var i = 0; i < max; i++) {
      var id = prefs.getInt('dataKomik[$i][id]');
      var title = prefs.getString('dataKomik[$i][title]');
      var cover = prefs.getString('dataKomik[$i][cover]');
      if (id != null && title != null && cover != null) {
        comics.add({'id': id, 'title': title, 'cover': cover});
      }
    }

    return comics;
  }

  Future<void> getComicDetail(int id) async {
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl + 'comic/$id');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('comicId', id);
      var token = prefs.getString('token');
      if (token == null) {
        Get.offAll(() => LoginScreen());
      } else {
        var headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        http.Response response = await http.get(url, headers: headers);

        final json = jsonDecode(response.body);
        if (json['status'] == 'success') {
          prefs.setString('comicTitle', json['data']['title']);
          prefs.setString('comicCover', json['data']['cover']);
          prefs.setString('comicDescription', json['data']['description']);
          print('Comic Title: ${json['data']['title']}');
          print('Comic Cover: ${json['data']['cover']}');
          print('Comic Description: ${json['data']['description']}');
        } else {
          Get.showSnackbar(GetSnackBar(
            title: json['status'],
            message: json['message'],
            icon: Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red, // Replace with your color scheme
          ));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getChapterDetail(int comicId, int chapterId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      if (token == null) {
        Get.offAll(() => LoginScreen());
        return;
      }

      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndPoints.Comics}/$comicId/chapters/$chapterId');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(url, headers: headers);
      var json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        var chapterDetail = json['data'];
        prefs.setString('chapterDetail', jsonEncode(chapterDetail));
      } else {
        Get.showSnackbar(GetSnackBar(
          title: 'Error',
          message: json['message'],
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: e.toString(),
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> getChapters(int id) async {
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.Comics +
          '/$id' +
          '/chapters');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('comicId', id);
      var token = prefs.getString('token');
      if (token == null) {
        Get.offAll(() => LoginScreen());
      } else {
        var headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        http.Response response = await http.get(url, headers: headers);

        final json = jsonDecode(response.body);
        print(json);

        if (json['status'] == 'success') {
          // Clear previous chapter data
          prefs.remove('chapters');

          // Save new chapter data
          List<String> chapterList = [];
          for (var chapter in json['data']) {
            String chapterData =
                '${chapter['id']}|${chapter['title']}|${chapter['subtitle']}|${chapter['price']}|${chapter['purchased']}'; // Tambahkan purchased data di sini
            chapterList.add(chapterData);
          }
          prefs.setStringList('chapters', chapterList);
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
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> chapterPurchase(int chapterId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      if (token == null) {
        Get.offAll(() => LoginScreen());
        return;
      }

      var url = Uri.parse('${ApiEndPoints.baseUrl}chapter/$chapterId/purchase');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(url, headers: headers);
      var json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        Get.showSnackbar(GetSnackBar(
          title: 'Success',
          message: 'Chapter purchased successfully',
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        ));
      } else {
        Get.showSnackbar(GetSnackBar(
          title: 'Error',
          message: json['message'],
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e);
      Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: e.toString(),
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));
    }
  }
}
