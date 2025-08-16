import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Full base URL including /api
  final String baseUrl = "https://hireorbit.onrender.com";

  /// ✅ Register user
  Future<bool> register(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        // optionally add 'email': '', if your backend allows
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Register failed: ${response.body}');
      return false;
    }
  }

  /// ✅ Login user
  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  }

  /// ✅ Fetch email
  Future<String?> fetchEmail(String token) async {
    final url = Uri.parse('$baseUrl/user/email');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['email'];
    } else {
      print('Fetch email failed: ${response.body}');
      return null;
    }
  }

  /// ✅ Update email
  Future<bool> updateEmail(String token, String email) async {
    final url = Uri.parse('$baseUrl/auth/email');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Update email failed: ${response.body}');
      return false;
    }
  }
}