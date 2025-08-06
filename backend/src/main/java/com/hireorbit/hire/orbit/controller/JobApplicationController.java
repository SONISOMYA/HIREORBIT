package com.hireorbit.hire.orbit.controller;

import com.hireorbit.hire.orbit.entity.JobApplication;
import com.hireorbit.hire.orbit.entity.User;
import com.hireorbit.hire.orbit.service.JobApplicationService;
import com.hireorbit.hire.orbit.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/job_applications")
@RequiredArgsConstructor
public class JobApplicationController {

    private final JobApplicationService jobService;
    private final UserService userService;

    @PostMapping
    public ResponseEntity<JobApplication> create(
            @Valid @RequestBody JobApplication jobApplication,
            @AuthenticationPrincipal UserDetails userDetails) {

        System.out.println("🔥 Controller userDetails: " + userDetails);

        if (userDetails == null) {
            return ResponseEntity.status(403).body(null);
        }

        User user = userService.getByUsername(userDetails.getUsername());
        jobApplication.setUser(user);

        JobApplication saved = jobService.save(jobApplication);

        return ResponseEntity.status(201).body(saved);  // ✅ 201 Created!
    }

    @GetMapping
    public ResponseEntity<List<JobApplication>> getAll(
            @AuthenticationPrincipal UserDetails userDetails) {

        User user = userService.getByUsername(userDetails.getUsername());
        return ResponseEntity.ok(jobService.getAll(user));
    }

    @GetMapping("/filter")
    public ResponseEntity<List<JobApplication>> filterByStatus(
            @RequestParam String status,
            @AuthenticationPrincipal UserDetails userDetails) {

        User user = userService.getByUsername(userDetails.getUsername());
        List<JobApplication> filtered = jobService.filterByStatus(user, status);
        return ResponseEntity.ok(filtered);
    }


    @PutMapping("/{id}")
    public ResponseEntity<JobApplication> update(
            @PathVariable Long id,
            @Valid @RequestBody JobApplication updatedJob,
            @AuthenticationPrincipal UserDetails userDetails) {

        User user = userService.getByUsername(userDetails.getUsername());

        return (ResponseEntity<JobApplication>) jobService.getById(id).map(existing -> {
            // ✅ Ownership check
            if (!existing.getUser().getId().equals(user.getId())) {
                return ResponseEntity.status(403).build();
            }

            updatedJob.setId(id);
            updatedJob.setUser(user);

            return ResponseEntity.ok(jobService.save(updatedJob));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Object> delete(
            @PathVariable Long id,
            @AuthenticationPrincipal UserDetails userDetails) {

        User user = userService.getByUsername(userDetails.getUsername());

        return jobService.getById(id).map(jobApplication -> {
            if (!jobApplication.getUser().getId().equals(user.getId())) {
                return ResponseEntity.status(403).build();  // 👈 NO .body(null)
            }
            jobService.delete(id);
            return ResponseEntity.ok().build();
        }).orElse(ResponseEntity.notFound().build());
    }
}