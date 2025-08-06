import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hireorbit/core/constants/glass_container.dart';
import 'package:hireorbit/core/constants/custom_glass_dropdown.dart';
import 'package:hireorbit/features/jobs/screens/add_edit_job_screen.dart';
import 'package:hireorbit/features/jobs/widgets/job_card.dart';
import 'package:hireorbit/providers/auth_provider.dart';
import 'package:hireorbit/providers/job_provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<JobProvider>(context, listen: false).fetchJobs(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final jobProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Applications',
          style: AppTextStyles.h2.copyWith(color: Colors.black87),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            tooltip: 'Log out',
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            /// ✅ Glass filter bar
            GlassContainer(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: CustomGlassDropdown(
                      value: jobProvider.filterStatus.isEmpty
                          ? null
                          : jobProvider.filterStatus,
                      hintText: '🔎 Filter by Status',
                      items: [
                        'Not Applied',
                        'Applied',
                        'In Progress',
                        'Interview Scheduled',
                        'Interviewed',
                        'Offer Received',
                        'Accepted',
                        'Rejected',
                        'On Hold',
                        'Withdrawn',
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          jobProvider.filterStatus = val;
                          jobProvider.fetchJobs();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(
                        color: Colors.black12.withOpacity(0.2),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => jobProvider.clearFilter(),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// ✅ Jobs List
            Expanded(
              child: jobProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : jobProvider.jobs.isEmpty
                      ? Center(
                          child: Text(
                            'No applications found.\nTap ➕ to add one!',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: jobProvider.jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobProvider.jobs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: JobCard(
                                job: job,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditJobScreen(
                                        existingJob: job,
                                      ),
                                    ),
                                  );
                                },
                                onDelete: () async {
                                  await jobProvider.deleteJob(job.id!);
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditJobScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
