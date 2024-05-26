import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/auth/welcome_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> changeEmail() async {
    try {
      //cek email valid
      if (emailController.text.isEmail) {
        var Url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.EditProfile);
        final SharedPreferences? prefs = await _prefs;
        var token = prefs?.getString('token');

        var header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        File image = File(prefs!.getString('image')!);

        // Get the image from network and cache it
        http.Response getFile =
            await http.get(Uri.parse(prefs.getString('image')!));
        Uint8List bytes = getFile.bodyBytes;
        await image.writeAsBytes(bytes);
        print(image.path);
        var request = http.MultipartRequest('POST', Url);

        //take the file
        var multipartFile =
            await http.MultipartFile.fromPath('picture', image.path);

        request.files.add(multipartFile);
        //genreList to list<int>
        request.fields['name'] = prefs.getString('name')!;
        request.fields['email'] = emailController.text;
        request.fields['age'] = prefs.getInt('age').toString();
        request.fields['password'] = prefs.getString('password')!;
        request.headers.addAll(header);
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);

        if (json['status'] == 'success') {
          await getProfile();
          emailController.clear();
          Get.showSnackbar(GetSnackBar(
            title: json['status'],
            message: json['message'],
            icon: Icon(Icons.check, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.primary,
          ));
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
          title: 'Error',
          message: 'Email is not valid',
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.error,
        ));
        return;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> changeAge() async {
    try {
      if (!ageController.text.isEmpty) {
        var Url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.EditProfile);
        final SharedPreferences? prefs = await _prefs;
        var token = prefs?.getString('token');

        var header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        File image = File(prefs!.getString('image')!);

        // Get the image from network and cache it
        http.Response getFile =
            await http.get(Uri.parse(prefs.getString('image')!));
        Uint8List bytes = getFile.bodyBytes;
        await image.writeAsBytes(bytes);
        print(image.path);
        var request = http.MultipartRequest('POST', Url);

        //take the file
        var multipartFile =
            await http.MultipartFile.fromPath('picture', image.path);

        request.files.add(multipartFile);
        //genreList to list<int>
        request.fields['name'] = prefs.getString('name')!;
        request.fields['email'] = prefs.getString('email')!;
        request.fields['age'] = ageController.text;
        request.fields['password'] = prefs.getString('password')!;
        request.headers.addAll(header);
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);

        if (json['status'] == 'success') {
          await getProfile();
          ageController.clear();
          Get.showSnackbar(GetSnackBar(
            title: json['status'],
            message: json['message'],
            icon: Icon(Icons.check, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.primary,
          ));
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
          title: 'Error',
          message: 'Age cannot be empty',
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

  Future<void> changeUsername() async {
    try {
      if (!usernameController.text.isEmpty) {
        var Url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.EditProfile);
        final SharedPreferences? prefs = await _prefs;
        var token = prefs?.getString('token');

        var header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        File image = File(prefs!.getString('image')!);

        // Get the image from network and cache it
        http.Response getFile =
            await http.get(Uri.parse(prefs.getString('image')!));
        Uint8List bytes = getFile.bodyBytes;
        await image.writeAsBytes(bytes);
        print(image.path);
        var request = http.MultipartRequest('POST', Url);

        //take the file
        var multipartFile =
            await http.MultipartFile.fromPath('picture', image.path);

        request.files.add(multipartFile);
        //genreList to list<int>
        request.fields['name'] = usernameController.text;
        request.fields['email'] = prefs.getString('email')!;
        request.fields['age'] = prefs.getInt('age').toString();
        request.fields['password'] = prefs.getString('password')!;
        request.headers.addAll(header);
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);

        if (json['status'] == 'success') {
          await getProfile();
          usernameController.clear();
          Get.showSnackbar(GetSnackBar(
            title: json['status'],
            message: json['message'],
            icon: Icon(Icons.check, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.primary,
          ));
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
          title: 'Error',
          message: 'Username cannot be empty',
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

  Future<void> changeImage(String imagePath) async {
    try {
      if (!imagePath.isEmpty) {
        var Url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.EditProfile);
        final SharedPreferences? prefs = await _prefs;
        var token = prefs?.getString('token');

        var header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        File image = File(imagePath);
        print(image.path);
        var request = http.MultipartRequest('POST', Url);

        //take the file
        var multipartFile =
            await http.MultipartFile.fromPath('picture', image.path);

        request.files.add(multipartFile);
        //genreList to list<int>
        request.fields['name'] = prefs!.getString('name')!;
        request.fields['email'] = prefs.getString('email')!;
        request.fields['age'] = prefs.getInt('age').toString();
        request.fields['password'] = prefs.getString('password')!;
        request.headers.addAll(header);
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);

        if (json['status'] == 'success') {
          await getProfile();
          Get.showSnackbar(GetSnackBar(
            title: json['status'],
            message: json['message'],
            icon: Icon(Icons.check, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.primary,
          ));
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

  Future<void> changePassword() async {
    try {
      if (newPasswordController.text != confirmPasswordController.text) {
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.showSnackbar(GetSnackBar(
          title: 'Error',
          message: 'Password not match',
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.error,
        ));
      } else {
        var Url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.EditProfile);
        final SharedPreferences? prefs = await _prefs;
        var token = prefs?.getString('token');

        var header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        File image = File(prefs!.getString('image')!);

        // Get the image from network and cache it
        http.Response getFile =
            await http.get(Uri.parse(prefs.getString('image')!));
        Uint8List bytes = getFile.bodyBytes;
        await image.writeAsBytes(bytes);
        print(image.path);
        var request = http.MultipartRequest('POST', Url);

        //take the file
        var multipartFile =
            await http.MultipartFile.fromPath('picture', image.path);

        request.files.add(multipartFile);
        //genreList to list<int>
        request.fields['name'] = prefs.getString('name')!;
        request.fields['email'] = prefs.getString('email')!;
        request.fields['age'] = prefs.getInt('age').toString();
        request.fields['password'] = newPasswordController.text;
        request.headers.addAll(header);
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);
        print(json);

        if (json['status'] == 'success') {
          await getProfile();
          newPasswordController.clear();
          confirmPasswordController.clear();
          Get.showSnackbar(GetSnackBar(
            title: json['status'],
            message: json['message'],
            icon: Icon(Icons.check, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.primary,
          ));
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

  //Make topup coin
  Future<void> topupCoin() async {
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
      var body = jsonEncode({'amount': 1000});

      http.Response response = await http.post(Url, headers: header);
    } catch (e) {
      print(e.toString());
    }
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
        var image = json['data']['picture'];
        var lastTwoDirectories =
            image.split('/').sublist(image.split('/').length - 1).join('/');
        if (lastTwoDirectories == 'picture') {
          prefs?.setString('image', '');
        } else {
          prefs?.setString('image', json['data']['picture']);
        }
        print(prefs?.getString('image'));

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
