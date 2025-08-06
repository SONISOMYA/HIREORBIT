import 'package:flutter/material.dart';
import 'package:hireorbit/core/services/job_service.dart';
import 'package:hireorbit/features/jobs/models/job_application.dart';

class JobProvider extends ChangeNotifier {
  final JobService service;

  List<JobApplication> jobs = [];
  bool isLoading = false;

  // ✅ Default filter status is empty = no filter
  String filterStatus = '';

  JobProvider({required this.service});

  Future<void> fetchJobs() async {
    isLoading = true;
    notifyListeners();

    try {
      if (filterStatus.isEmpty) {
        jobs = await service.getAll();
      } else {
        jobs = await service.getFiltered(status: filterStatus);
      }
    } catch (e) {
      debugPrint('Error fetching jobs: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addJob(JobApplication job) async {
    await service.create(job);
    await fetchJobs();
  }

  Future<void> updateJob(JobApplication job) async {
    await service.update(job);
    await fetchJobs();
  }

  Future<void> deleteJob(int id) async {
    await service.delete(id);
    await fetchJobs();
  }

  void clearFilter() {
    filterStatus = '';
    fetchJobs();
  }
}