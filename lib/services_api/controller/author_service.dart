import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AuthorController extends GetxService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController genreIdController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController rateController = TextEditingController();

  TextEditingController passWithdrawalController = TextEditingController();

  Future<void> addComic() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Comics);

      var path_cover = prefs?.getString('cover_image');
      if (path_cover != null) {
        File cover = File(path_cover);
        var request = http.MultipartRequest('POST', url);

        //take the file
        var multipartFile =
            await http.MultipartFile.fromPath('cover', cover.path);

        request.files.add(multipartFile);
        //genreList to list<int>
        var genreList =
            genreIdController.text.split(',').map(int.parse).toList();

        request.fields['title'] = titleController.text;
        request.fields['description'] = descriptionController.text;
        request.fields['author'] = prefs!.getString('name')!;
        request.fields['price'] = priceController.text;
        //insert list<int> to request.fields
        for (var i = 0; i < genreList.length; i++) {
          request.fields['genres_id[$i]'] = genreList[i].toString();
        }

        request.headers.addAll(headers);
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);
        print(json);

        if (json['status'] == 'success') {
          //getx back to previous page
          titleController.clear();
          descriptionController.clear();
          genreIdController.clear();
          prefs.remove('cover_image');
          priceController.clear();
          rateController.clear();
          Get.back();
          Get.showSnackbar(GetSnackBar(
            title: "Sukses",
            message: 'Komik berhasil ditambahkan',
            icon: Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          ));
        } else {
          Get.showSnackbar(GetSnackBar(
            title: "Failed",
            message: json['message'],
            icon: Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          ));
        }
      } else {
        Get.showSnackbar(GetSnackBar(
          title: "Failed",
          message: "Chose cover image first",
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

  Future<void> getGenre() async {
    try {
      var Url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Genres);
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
        if (prefs?.getInt('genre[Max]') != null) {
          var j = prefs?.getInt('genre[Max]');
          for (var i = 0; i < j!; i++) {
            prefs?.remove('genre[$i][name]');
            prefs?.remove('genre[$i][id]');
          }
          prefs?.remove('genre[Max]');
        }

        prefs?.setInt('genre[Max]', json['data'].length);
        for (var i = 0; i < json['data'].length; i++) {
          prefs?.setString('genre[$i][name]', json['data'][i]['name']);
          prefs?.setInt('genre[$i][id]', json['data'][i]['id']);
        }
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

  //get history withdrawal
  Future<void> getHistoryWithdrawal() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Withdrawal);

      http.Response response = await http.get(url, headers: headers);

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        if (prefs?.getInt('withdrawal[Max]') != null) {
          var j = prefs?.getInt('withdrawal[Max]');
          for (var i = 0; i < j!; i++) {
            prefs?.remove('withdrawal[$i][amount]');
            prefs?.remove('withdrawal[$i][status]');
            prefs?.remove('withdrawal[$i][created_at]');
          }
          prefs?.remove('withdrawal[Max]');
        }

        prefs?.setInt('withdrawal[Max]', json['data'].length);
        for (var i = 0; i < json['data'].length; i++) {
          prefs?.setInt('withdrawal[$i][amount]', json['data'][i]['amount']);
          prefs?.setString('withdrawal[$i][status]', json['data'][i]['status']);
          prefs?.setString(
              'withdrawal[$i][created_at]', json['data'][i]['created_at']);
        }
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

  //withdrawal
  Future<void> withdrawal() async {
    try {
      //check if password is empty
      if (passWithdrawalController.text.isEmpty) {
        Get.showSnackbar(GetSnackBar(
          title: "Failed",
          message: "Password is empty",
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
        return;
      } else {
        //check if password is correct with login password
        final SharedPreferences? prefs = await _prefs;
        if (prefs?.getString('password') != passWithdrawalController.text) {
          Get.showSnackbar(GetSnackBar(
            title: "Failed",
            message: "Password is incorrect",
            icon: Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          ));
          passWithdrawalController.clear();
          return;
        } else {
          //make request post withdraw
          var token = prefs?.getString('token');

          var headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          };

          var url = Uri.parse(
              ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Withdrawal);

          Map body = {
            'amount': prefs?.getInt('coin'),
          };

          http.Response response =
              await http.post(url, body: jsonEncode(body), headers: headers);
          final json = jsonDecode(response.body);

          if (json['status'] == 'success') {
            passWithdrawalController.clear();
            Get.showSnackbar(GetSnackBar(
              title: "Sukses",
              message: json['message'],
              icon: Icon(Icons.check_circle, color: Colors.white),
              duration: const Duration(seconds: 5),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
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
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
