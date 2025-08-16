// import 'dart:convert';
// import 'package:http/http.dart' as http;  // 👈 this import was missing

// class ApiService {
//   final String baseUrl = "https://hireorbit.onrender.com/api"; 
 
//   // POST request
//   Future<http.Response> post(String path, Map<String, dynamic> body,
//       {Map<String, String>? headers}) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl$path'),
//       headers: {
//         'Content-Type': 'application/json',
//         ...?headers,
//       },
//       body: jsonEncode(body),
//     );
//     return response;
//   }

//   // GET request
//   Future<http.Response> get(String path, {Map<String, String>? headers}) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl$path'),
//       headers: headers,
//     );
//     return response;
//   }

//   // PUT request
//   Future<http.Response> put(String path, Map<String, dynamic> body,
//       {Map<String, String>? headers}) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl$path'),
//       headers: {
//         'Content-Type': 'application/json',
//         ...?headers,
//       },
//       body: jsonEncode(body),
//     );
//     return response;
//   }
// }
