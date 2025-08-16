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

        JobApplication savedJob = repository.save(jobApplication);

        if (isNew && email != null && !email.isEmpty()) {
            String subject = "New Job Added : " + savedJob.getCompany();
            String body = "<h2>Job Added Successfully</h2>"
                    + "<p><strong>Company:</strong> " + savedJob.getCompany() + "</p>"
                    + "<p><strong>Role:</strong> " + savedJob.getTitle() + "</p>"
                    + "<p><strong>Deadline:</strong> " + savedJob.getDeadline() + "</p>";

            emailSenderService.sendEmail(email, subject, body);
        }

        return savedJob;
    }

    public List<JobApplication> getAll(User user) {
        // Use eager fetch method to avoid LazyInitializationException
        return repository.findByUserWithUser(user);
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