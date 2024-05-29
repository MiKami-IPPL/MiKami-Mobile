import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/author/chapter_manage_screen.dart';
import 'package:mikami_mobile/services_api/controller/profile_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorController extends GetxService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController genreIdController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController passWithdrawalController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  TextEditingController amountController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  Future<void> uploadChapter() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var comicId = prefs.getInt('comicId');
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.Comics +
          '/$comicId/chapters');

      var image = prefs.getStringList('images');
      if (image != null) {
        var request = http.MultipartRequest('POST', url);
        List<File> imageList = [];
        for (var path in image) {
          File chapter = File(path);
          imageList.add(chapter);
        }

        //take the files
        for (var chapter in imageList) {
          var multipartFile =
              await http.MultipartFile.fromPath('images', chapter.path);
          request.files.add(multipartFile);
        }

        request.fields['title'] = titleController.text;
        request.fields['subtitle'] = subtitleController.text;
        request.fields['price'] = priceController.text;

        request.headers.addAll(headers);
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);
        print(json);

        if (json['status'] == 'success') {
          //getx back to previous page
          titleController.clear();
          priceController.clear();
          subtitleController.clear();
          prefs.remove('images');
          Get.showSnackbar(GetSnackBar(
            title: "Sukses",
            message: 'Komik berhasil ditambahkan',
            icon: Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          ));

          Get.back();
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

  Future<void> deleteChapter(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      var comicId = prefs.getInt('comicId');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url =
          Uri.parse(ApiEndPoints.baseUrl + 'chapters' + '/$id' + '/delete');
      print(url);

      http.Response response = await http.delete(url, headers: headers);

      final json = jsonDecode(response.body);

      if (json['status'] == 'success') {
        Get.showSnackbar(GetSnackBar(
          title: 'Deleted Chapter',
          message: 'Chapter successfully deleted',
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        ));
        await getChapters(comicId!);
      } else {
        Get.showSnackbar(GetSnackBar(
          title: "Error",
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
        Get.offAll(() => profileController.logout());
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
                '${chapter['id']}|${chapter['title']}|${chapter['subtitle']}';
            chapterList.add(chapterData);
          }
          prefs.setStringList('chapters', chapterList);

          Get.to(() => ChapterManageScreen());
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

  Future<void> getAuthorComics() async {
    try {
      var Url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.ComicsByAuthor);
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');
      if (token == null) {
        Get.offAll(() => profileController.logout());
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
          if (prefs?.getInt('authKomik[Max]') != null) {
            var j = prefs?.getInt('authKomik[Max]');
            for (var i = 0; i < j!; i++) {
              //id
              prefs?.remove('authKomik[$i][id]');
              prefs?.remove('authKomik[$i][title]');
              prefs?.remove('authKomik[$i][description]');
              prefs?.remove('authKomik[$i][price]');
              prefs?.remove('authKomik[$i][genres]');
              prefs?.remove('authKomik[$i][cover]');
            }
            prefs?.remove('authKomik[Max]');
          }

          prefs?.setInt('authKomik[Max]', json['data'].length);
          for (var i = 0; i < json['data'].length; i++) {
            //id
            prefs?.setInt('authKomik[$i][id]', (json['data'][i]['id']));
            prefs?.setString(
                'authKomik[$i][title]', (json['data'][i]['title']));
            //set cover
            prefs?.setString(
                'authKomik[$i][cover]', (json['data'][i]['cover']));
            prefs?.setString('authKomik[$i][description]',
                jsonEncode(json['data'][i]['description']));
            prefs?.setInt('authKomik[$i][price]', (json['data'][i]['price']));
            String genres = '';
            for (var j = 0; j < json['data'][i]['genres'].length; j++) {
              genres += json['data'][i]['genres'][j]['name'].toString() + ', ';
            }
            prefs?.setString('authKomik[$i][genres]', genres);
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

  Future<void> updateComic(
      int comicId, Map<String, dynamic> updatedData) async {
    try {
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.Comics +
          '/$comicId/update');

      // Validate rate and price fields
      double? rate;
      double? price;
      if (double.tryParse(rateController.text) != null) {
        rate = double.parse(rateController.text);
      }
      if (double.tryParse(priceController.text) != null) {
        price = double.parse(priceController.text);
      }

      if (rate == null || price == null) {
        // Display error message if rate or price is invalid
        Get.showSnackbar(GetSnackBar(
          title: "Error",
          message: 'Rate and price must be valid numbers',
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
        return;
      }

      // Set rate and price in the updated data
      updatedData['rate'] = rate;
      updatedData['price'] = price;

      http.Response response = await http.put(
        url,
        body: jsonEncode(updatedData),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        if (json['status'] == 'success') {
          Get.showSnackbar(GetSnackBar(
            title: "Success",
            message: 'Comic successfully updated',
            icon: Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          ));
          // Refresh the list of comics after update
          // await getComics();
        } else {
          // Handle API error response
          Get.showSnackbar(GetSnackBar(
            title: "Error",
            message: json['message'],
            icon: Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          ));
        }
      } else {
        // Handle HTTP error response
        Get.showSnackbar(GetSnackBar(
          title: "Error",
          message: 'Failed to update comic: HTTP ${response.statusCode}',
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print("Error updating comic: $e");
      Get.showSnackbar(GetSnackBar(
        title: "Error",
        message: 'An error occurred while updating the comic',
        icon: Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<String> deleteComic(int comicId, String title) async {
    try {
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.authEndPoints.Comics +
          '/$comicId/delete');

      http.Response response = await http.delete(url, headers: headers);
      final json = jsonDecode(response.body);
      print(json);

      if (json['status'] == 'success') {
        Get.showSnackbar(GetSnackBar(
          title: 'Deleted $title',
          message: 'Comic successfully deleted',
          icon: Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        ));
        return 'success';
      } else {
        Get.showSnackbar(GetSnackBar(
          title: "Error",
          message: json['message'],
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
        return 'error';
      }
    } catch (e) {
      print(e.toString());
      return 'error';
    }
  }

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

        if (json['status'] == 'success') {
          //getx back to previous page
          titleController.clear();
          descriptionController.clear();
          genreIdController.clear();
          prefs.remove('cover_image');
          priceController.clear();
          rateController.clear();
          Get.showSnackbar(GetSnackBar(
            title: "Sukses",
            message: 'Komik berhasil ditambahkan',
            icon: Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          ));

          Get.back();
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
      } else if (amountController.text.isEmpty) {
        Get.showSnackbar(GetSnackBar(
          title: "Failed",
          message: "Amount is empty",
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        ));
        return;
      } else if (int.parse(amountController.text) < 100) {
        Get.showSnackbar(GetSnackBar(
          title: "Failed",
          message: "Minimum withdrawal is 100",
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
            'amount': amountController.text,
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
