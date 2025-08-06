package com.hireorbit.hire.orbit.config;

import com.hireorbit.hire.orbit.entity.User;
import com.hireorbit.hire.orbit.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AdminSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        if (!userRepository.existsByUsername("admin")) {
            User user = new User();
            user.setUsername("admin");
            user.setPassword(passwordEncoder.encode("admin123"));
            user.setRole("ADMIN");
            userRepository.save(user);
            System.out.println("✅ Admin user created");
        } else {
            System.out.println("ℹ️ Admin already exists.");
        }
    }
}