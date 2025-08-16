import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://hireorbit.onrender.com";

  /// Register user
  Future<bool> register(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      print('Register failed: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Register exception: $e');
      return false;
    }
  }

  /// Login user
  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sometimes token might be nested in 'data' or directly as 'token'
        if (data.containsKey('token')) return data['token'];
        if (data.containsKey('data') && data['data'].containsKey('token')) {
          return data['data']['token'];
        }

        print('Login response missing token: $data');
        return null;
      }

      print('Login failed: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      print('Login exception: $e');
      return null;
    }
  }

  /// Fetch user email
  Future<String?> fetchEmail(String token) async {
    final url = Uri.parse('$baseUrl/api/auth/profile');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['email'] ??
            data['username']; // fallback if email not returned
      }

      print('Fetch email failed: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      print('Fetch email exception: $e');
      return null;
    }
  }

  /// Update user email
  Future<bool> updateEmail(String token, String email) async {
    final url = Uri.parse('$baseUrl/api/auth/email');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) return true;

      print('Update email failed: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Update email exception: $e');
      return false;
    }
  }
}
