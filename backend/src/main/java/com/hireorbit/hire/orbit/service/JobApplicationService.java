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

    public JobApplication save(JobApplication jobApplication) {
        return repository.save(jobApplication);
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
}