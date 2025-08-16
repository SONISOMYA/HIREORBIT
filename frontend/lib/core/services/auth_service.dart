import 'dart:convert';
import '../services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> register(String username, String password) async {
    final response = await _apiService.post('/auth/register', {
      'username': username,
      'password': password,
    });

    return response.statusCode == 200;
  }

  Future<String?> login(String username, String password) async {
    final response = await _apiService.post('/auth/login', {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  }

  Future<String?> fetchEmail(String token) async {
    final response = await _apiService.get(
      '/user/email',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['email'];
    } else {
      return null;
    }
  }

  Future<bool> updateEmail(String token, String email) async {
    final response = await _apiService.put(
      '/auth/email',
      {'email': email},
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}
