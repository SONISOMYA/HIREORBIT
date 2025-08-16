import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "https://hireorbit.onrender.com";

  Future<bool> register(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) return true;
    print('Register failed: ${response.body}');
    return false;
  }

  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    }
    print('Login failed: ${response.body}');
    return null;
  }

  Future<String?> fetchEmail(String token) async {
    final url = Uri.parse('$baseUrl/api/auth/profile'); // ✅ corrected
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['email']; // make sure backend returns email
    }
    print('Fetch email failed: ${response.body}');
    return null;
  }

  Future<bool> updateEmail(String token, String email) async {
    final url = Uri.parse('$baseUrl/api/auth/email'); // ✅ corrected
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) return true;
    print('Update email failed: ${response.body}');
    return false;
  }
}
