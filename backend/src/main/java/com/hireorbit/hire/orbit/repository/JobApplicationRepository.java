package com.hireorbit.hire.orbit.repository;

import com.hireorbit.hire.orbit.entity.JobApplication;
import com.hireorbit.hire.orbit.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface JobApplicationRepository extends JpaRepository<JobApplication, Long> {

    List<JobApplication> findByUser(User user);

    List<JobApplication> findByUserAndStatusIgnoreCase(User user, String status);

    // ✅ NEW METHOD: Eagerly fetch associated User to prevent LazyInitializationException
    @Query("SELECT j FROM JobApplication j JOIN FETCH j.user")
    List<JobApplication> findAllWithUser();
}