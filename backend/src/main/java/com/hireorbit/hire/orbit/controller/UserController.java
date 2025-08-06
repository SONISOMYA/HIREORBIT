package com.hireorbit.hire.orbit.controller;


import com.hireorbit.hire.orbit.payload.UpdateEmailRequest;
import com.hireorbit.hire.orbit.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/profile")
    public ResponseEntity<String> getProfile() {
        return ResponseEntity.ok("✅ You are authenticated — Welcome to your profile!");
    }

    @PutMapping("/update-email")
    public ResponseEntity<String> updateEmail(@RequestBody UpdateEmailRequest request, Principal principal) {
        userService.updateEmail(principal.getName(), request.getEmail());
        return ResponseEntity.ok("📧 Email updated successfully!");
    }
}