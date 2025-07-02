import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hireorbit/features/jobs/models/job_application.dart';

class JobService {
  final String jwt;

  JobService({required this.jwt});

  final String baseUrl = 'http://localhost:8080/api/job_applications';

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      };

  Future<List<JobApplication>> getAll() async {
    final res = await http.get(Uri.parse(baseUrl), headers: _headers);
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => JobApplication.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch jobs');
    }
  }

  Future<void> create(JobApplication job) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonEncode(job.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create job → ${response.body}');
    }
  }

  Future<void> update(JobApplication job) async {
    final res = await http.put(
      Uri.parse('$baseUrl/${job.id}'),
      headers: _headers,
      body: json.encode(job.toJson()),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to update job');
    }
  }

  Future<void> delete(int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to delete job');
    }
  }
}
