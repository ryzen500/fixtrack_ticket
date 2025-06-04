import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      // baseUrl: 'http://10.0.2.2:8000/api', // Android Emulator
      baseUrl: 'http://127.0.0.1:8000/api', // Run as chrome
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<bool> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'];
      final user = response.data['user']; // <-- Ambil data user dari response
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      /**
     * Set Login user_id
     */

      if (user != null) {
        await prefs.setInt('user_id', user['id']); // <-- Simpan user_id
        print("User ID disimpan: ${user['id']}");
      } else {
        print("Tidak ada data user dalam response login");
      }
      return true;
    } on DioException catch (e) {
      print("Login error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  Future<List<dynamic>> getTickets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        '/tickets',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Cek tipe data response.data
      if (response.data is List) {
        return response.data as List<dynamic>;
      } else if (response.data is Map && response.data['data'] != null) {
        return response.data['data'] as List<dynamic>;
      } else {
        throw Exception('Format data tiket tidak sesuai');
      }
    } on DioException catch (e) {
      print("Get tickets error: ${e.response?.data ?? e.message}");
      return [];
    }
  }

  Future<List<dynamic>> getCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        '/categories',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data as List<dynamic>;
    } catch (e) {
      print("Get categories error: $e");
      return [];
    }
  }

  Future<bool> createTicket(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      print('🟢 Sending create ticket request with data:');
      print(data);

      final response = await _dio.post(
        '/tickets',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print(
        '✅ Ticket created successfully with status: ${response.statusCode}',
      );
      return response.statusCode == 201;
    } on DioException catch (e) {
      print('❌ DioException during ticket creation');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Message: ${e.message}');
      return false;
    } catch (e) {
      print('❗ Unexpected error: $e');
      return false;
    }
  }

  Future<List<dynamic>> getComments() async {
    try {
      final response = await _dio.get('/comments');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      print("Error fetching comments: ${e.response?.data ?? e.message}");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfile(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await _dio.get(
      '/auth/me/$userId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data as Map<String, dynamic>;
  }

  Future<bool> updateProfile(int userId, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      await _dio.put(
        '/auth/updateProfile/$userId',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return true;
    } on DioException catch (e) {
      print("Update profile error: ${e.response?.data ?? e.message}");
      return false;
    }
  }

 Future<String> updatePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await _dio.put(
      '/auth/updatePassword/$userId',
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': confirmPassword,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    return response.data['message'];
  }

}
