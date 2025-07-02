import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hireorbit/features/jobs/screens/add_edit_job_screen.dart';
import 'package:hireorbit/providers/auth_provider.dart';
import 'package:hireorbit/providers/job_provider.dart';
import 'package:hireorbit/features/jobs/widgets/job_card.dart';

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
      appBar: AppBar(
        title: const Text('My Applications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: jobProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobProvider.jobs.isEmpty
              ? const Center(
                  child: Text(
                    'No applications yet.\nTap + to add one!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobProvider.jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobProvider.jobs[index];
                    return JobCard(
                      job: job,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditJobScreen(existingJob: job),
                          ),
                        );
                      },
                      onDelete: () async {
                        await jobProvider.deleteJob(job.id!);
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
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
