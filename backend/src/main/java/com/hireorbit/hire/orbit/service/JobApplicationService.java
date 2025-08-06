package com.hireorbit.hire.orbit.service;

import com.hireorbit.hire.orbit.entity.JobApplication;
import com.hireorbit.hire.orbit.entity.User;
import com.hireorbit.hire.orbit.repository.JobApplicationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class JobApplicationService {

    private final JobApplicationRepository repository;
    private final EmailSenderService emailSenderService;

    public JobApplication save(JobApplication jobApplication) {
        boolean isNew = (jobApplication.getId() == null);
        String email = jobApplication.getUser().getEmail();

        JobApplication savedJob;

        if (isNew) {
            // 🆕 New job
            savedJob = repository.save(jobApplication);

            if (email != null && !email.isEmpty()) {
                String subject = "New Job Added : " + savedJob.getCompany();
                String body = "<h2>Job Added Successfully</h2>"
                        + "<p><strong>Company:</strong> " + savedJob.getCompany() + "</p>"
                        + "<p><strong>Role:</strong> " + savedJob.getTitle() + "</p>"
                        + "<p><strong>Deadline:</strong> " + savedJob.getDeadline() + "</p>";

                emailSenderService.sendEmail(email, subject, body);
            }

        } else {
            // ✏️ Existing job - check for status change
            Optional<JobApplication> existingOpt = repository.findById(jobApplication.getId());

            if (existingOpt.isPresent()) {
                JobApplication existing = existingOpt.get();
                String oldStatus = existing.getStatus();
                String newStatus = jobApplication.getStatus();

                savedJob = repository.save(jobApplication);

                // 📨 Only send if status actually changed
                if (!oldStatus.equalsIgnoreCase(newStatus)) {
                    if (email != null && !email.isEmpty()) {
                        String subject = "Job Status Updated: " + newStatus;
                        String body = "<h2>Status Updated</h2>"
                                + "<p><strong>Company:</strong> " + savedJob.getCompany() + "</p>"
                                + "<p><strong>Role:</strong> " + savedJob.getTitle() + "</p>"
                                + "<p><strong>New Status:</strong> " + newStatus + "</p>";

                        emailSenderService.sendEmail(email, subject, body);
                    }
                }
            } else {
                // 🛑 Fallback — job not found, save anyway (shouldn't usually happen)
                savedJob = repository.save(jobApplication);
            }
        }

        return savedJob;
    }

    public List<JobApplication> getAll(User user) {
        return repository.findByUser(user);
    }

    public Optional<JobApplication> getById(Long id) {
        return repository.findById(id);
    }

    public void delete(Long id) {
        repository.deleteById(id);
    }

    public List<JobApplication> filterByStatus(User user, String status) {
        return repository.findByUserAndStatusIgnoreCase(user, status);
    }
}