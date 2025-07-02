import 'dart:convert';
import 'api_service.dart';

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
      // ignore: avoid_print
      print('Login failed: ${response.body}');
      return null;
    }
  }
}