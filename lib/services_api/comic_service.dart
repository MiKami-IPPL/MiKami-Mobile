import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mikami_mobile/model/comic.dart';
import 'package:mikami_mobile/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComicController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var comics = <Comic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchComics();
  }

  Future<void> fetchComics() async {
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
      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'success') {
          var comicList = (json['data'] as List)
              .map((comicData) => Comic.fromJson(comicData))
              .toList();
          comics.assignAll(comicList);
        } else {
          Get.snackbar('Error', json['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch comics');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
