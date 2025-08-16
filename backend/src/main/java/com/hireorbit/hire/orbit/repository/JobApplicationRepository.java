package com.hireorbit.hire.orbit.repository;

import com.hireorbit.hire.orbit.entity.JobApplication;
import com.hireorbit.hire.orbit.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface JobApplicationRepository extends JpaRepository<JobApplication, Long> {

    List<JobApplication> findByUser(User user);

    List<JobApplication> findByUserAndStatusIgnoreCase(User user, String status);

    // Fetch all jobs with associated User (for all users)
    @Query("SELECT j FROM JobApplication j JOIN FETCH j.user")
    List<JobApplication> findAllWithUser();

    // ✅ Fetch jobs for a specific user with their User eagerly loaded
    @Query("SELECT j FROM JobApplication j JOIN FETCH j.user WHERE j.user = :user")
    List<JobApplication> findByUserEager(@Param("user") User user);
}