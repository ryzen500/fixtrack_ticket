import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api', // Ganti sesuai backend-mu
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } on DioException catch (e) {
      print("Login error: ${e.response?.data ?? e.message}");
      return false;
    }
  }
}
