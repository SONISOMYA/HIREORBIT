import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_service.dart';

const String baseUrl =
    "https://hireorbit.onrender.com"; // or your actual backend URL

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

  Future<String?> fetchEmail(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/user/email'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['email'];
    } else {
      return null;
    }
  }

  Future<bool> updateEmail(String token, String email) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/email'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    return response.statusCode == 200;
  }
}
