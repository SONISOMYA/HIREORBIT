package com.hireorbit.hire.orbit.repository;

import com.hireorbit.hire.orbit.entity.JobApplication;
import com.hireorbit.hire.orbit.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface JobApplicationRepository extends JpaRepository<JobApplication, Long> {
    List<JobApplication> findByUser(User user);
}