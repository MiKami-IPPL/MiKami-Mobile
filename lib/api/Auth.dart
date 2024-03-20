import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio();
// untuk login
  Future login(String email, String password) async {
    try {
      final response = await _dio.post(
        'http://localhost:8000/api/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data;
    } catch (e) {
      throw e;
    }
  }
}
