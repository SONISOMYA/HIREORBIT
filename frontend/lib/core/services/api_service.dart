import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final baseUrl =
      "https://hireorbit.onrender.com"; // adjust for emulator/device

  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }
}
