import 'package:flutter/material.dart';
import 'package:hireorbit/core/constants/app_colors.dart';
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
    final isNotApplied = job.status == 'NOT_APPLIED';
    final formattedDeadline = job.deadline != null
        ? DateFormat('yyyy-MM-dd').format(job.deadline!)
        : 'No deadline set';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.whiteGlass,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title & Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title & Company
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.company,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Status Chip
                Chip(
                  label: Text(
                    job.status.replaceAll('_', ' '),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Deadline or Info
            Row(
              children: [
                Icon(
                  isNotApplied
                      ? Icons.calendar_today
                      : Icons.check_circle_outline,
                  size: 18,
                  color: isNotApplied ? AppColors.primary : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  isNotApplied
                      ? 'Deadline: $formattedDeadline'
                      : 'Already applied',
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Delete Button (Right aligned)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.black54,
                ),
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
