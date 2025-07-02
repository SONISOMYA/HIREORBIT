import 'package:flutter/material.dart';
import 'package:hireorbit/features/jobs/models/job_application.dart';
import 'package:intl/intl.dart';

class JobCard extends StatelessWidget {
  final JobApplication job;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDeadline = job.deadline != null
        ? DateFormat('yyyy-MM-dd').format(job.deadline!)
        : 'No Deadline';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title & Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    job.status,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.deepPurple.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            /// Company
            Text(
              job.company,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            /// Deadline
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 18, color: Colors.deepPurple),
                const SizedBox(width: 6),
                Text(
                  'Deadline: $formattedDeadline',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            /// Delete icon aligned right
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onDelete,
                tooltip: 'Delete Application',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
