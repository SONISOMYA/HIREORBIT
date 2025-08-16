package com.hireorbit.hire.orbit.controller;

import com.hireorbit.hire.orbit.entity.User;
import com.hireorbit.hire.orbit.payload.JwtResponse;
import com.hireorbit.hire.orbit.payload.LoginRequest;
import com.hireorbit.hire.orbit.payload.UpdateEmailRequest;
import com.hireorbit.hire.orbit.repository.UserRepository;
import com.hireorbit.hire.orbit.service.UserService;
import com.hireorbit.hire.orbit.util.JwtUtil;

import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;
    private final UserService userService;

    @RestController
    public class HomeController {
        @GetMapping("/")
        public String home() {
            return "🚀 HireOrbit Backend is running! Use /api/auth/... or /api/user/... endpoints.";
        }
    }


    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            return ResponseEntity.badRequest().body("Username already taken.");
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRole("USER");
        userRepository.save(user);

        return ResponseEntity.ok("User registered successfully!");
    }

    @PostMapping("/login")
    public ResponseEntity<JwtResponse> login(@RequestBody LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getUsername(),
                        loginRequest.getPassword()
                )
        );

        String username = authentication.getName();
        String token = jwtUtil.generateToken(username);

        return ResponseEntity.ok(new JwtResponse(token));
    }

    @GetMapping("/profile")
    public ResponseEntity<String> getProfile() {
        return ResponseEntity.ok("You are authenticated! ✅");
    }

    // ✅ New endpoint to update email
    @PutMapping("/email")
    public ResponseEntity<String> updateEmail(
            @RequestBody UpdateEmailRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {

        String username = userDetails.getUsername();
        userService.updateEmail(username, request.getEmail());

        return ResponseEntity.ok("✅ Email updated successfully!");
    }
}