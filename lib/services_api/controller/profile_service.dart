import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/screens/auth/welcome_screen.dart';
import 'package:mikami_mobile/screens/user/profile_screen.dart';
import 'package:mikami_mobile/services_api/controller/user_service.dart';
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
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  UserController usercontroller = Get.put(UserController());

  Future<void> upgradeAuthor() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      prefs?.remove('currentAddress');
      prefs?.setString('currentAddress', '');
      await placemarkFromCoordinates(position.latitude, position.longitude)
          .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        prefs?.setString('currentAddress',
            '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}, ${place.country}');
      });
      if (prefs!.getString('identity') == null ||
          prefs.getString('certificate') == null ||
          prefs.getString('selfie') == null) {
        Get.showSnackbar(GetSnackBar(
          title: 'Error',
          message: 'Please upload all the required documents',
          icon: Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: lightColorScheme.error,
        ));
        return;
      } else {
        print('Bisa upgrade');
        var Url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Upgrade);
        var token = prefs.getString('token');

        var header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };
        var request = http.MultipartRequest('POST', Url);
        File identity = File(prefs.getString('identity')!);
        File certificate = File(prefs.getString('certificate')!);
        File selfie = File(prefs.getString('selfie')!);

        var identityMultipartFile =
            await http.MultipartFile.fromPath('identity', identity.path);
        var certificateMultipartFile =
            await http.MultipartFile.fromPath('certificate', certificate.path);
        var selfieMultipartFile =
            await http.MultipartFile.fromPath('selfie', selfie.path);

        request.files.add(identityMultipartFile);
        request.files.add(certificateMultipartFile);
        request.files.add(selfieMultipartFile);

        request.fields['bank'] = bankNameController.text;
        request.fields['bankNumber'] = accountNumberController.text;
        request.fields['location'] = prefs.getString('currentAddress')!;

        request.headers.addAll(header);
        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);

        if (json['status'] == 'success') {
          print('disini');
          Get.showSnackbar(GetSnackBar(
            title: json['status'],
            message: "Upgrade success, please wait for admin approval",
            icon: Icon(Icons.check, color: Colors.white),
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.primary,
          ));
          bankNameController.clear();
          accountNumberController.clear();
          prefs.remove('identity');
          prefs.remove('certificate');
          prefs.remove('selfie');

          Get.to(() => ProfileScreen());
        } else {
          print('error');

          bankNameController.clear();
          accountNumberController.clear();
          prefs.remove('identity');
          prefs.remove('certificate');
          prefs.remove('selfie');
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

  Future<void> changeEmail() async {
    try {
      //cek email valid
      if (!emailController.text.isEmpty) {
        var Url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.EditProfile);
        final SharedPreferences? prefs = await _prefs;
        var token = prefs?.getString('token');

        var header = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        };

        Map body = {
          'name': prefs!.getString('name'),
          'email': emailController.text,
          'age': prefs.getInt('age').toString(),
          'password': prefs.getString('password'),
        };

        http.Response response =
            await http.post(Url, body: jsonEncode(body), headers: header);
        final json = jsonDecode(response.body);
        print(json);
        if (json['status'] == 'success') {
          getProfile();
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

        Map body = {
          'name': prefs!.getString('name'),
          'email': prefs.getString('email'),
          'age': ageController.text,
          'password': prefs.getString('password'),
        };

        http.Response response =
            await http.post(Url, body: jsonEncode(body), headers: header);
        final json = jsonDecode(response.body);

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

        Map body = {
          'name': usernameController.text,
          'email': prefs?.getString('email'),
          'age': prefs?.getInt('age').toString(),
          'password': prefs?.getString('password'),
        };

        http.Response response =
            await http.post(Url, body: jsonEncode(body), headers: header);
        final json = jsonDecode(response.body);

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
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.EditPicture);
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

        Map body = {
          'name': prefs!.getString('name'),
          'email': prefs.getString('email'),
          'age': prefs.getInt('age').toString(),
          'password': newPasswordController.text,
        };

        http.Response response =
            await http.post(Url, body: jsonEncode(body), headers: header);
        final json = jsonDecode(response.body);

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

  Future<void> getPrice() async {
    try {
      var Url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.Price);
      final SharedPreferences? prefs = await _prefs;
      var token = prefs?.getString('token');

      var header = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      http.Response response = await http.get(Url, headers: header);
      final json = jsonDecode(response.body);
      int price = int.parse(json['data']['price']);
      if (prefs?.getInt('price') != null) {
        prefs?.remove('price');
      }
      if (json['status'] == 'success') {
        print(json['data']['price']);
        prefs?.setInt('price', price);
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
        print(lastTwoDirectories);
        if (lastTwoDirectories == 'picture') {
          print('masauk');
          prefs?.setString('image', '');
        } else {
          prefs?.setString('image', json['data']['picture']);
        }
        print(prefs?.getString('image'));
        await getPrice();
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
