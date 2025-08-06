package com.hireorbit.hire.orbit.service;

import com.hireorbit.hire.orbit.entity.User;
import com.hireorbit.hire.orbit.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public User getByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found with username: " + username));
    }

    // ✅ Add this method to fix the error
    public void updateEmail(String username, String email) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setEmail(email);
        userRepository.save(user);
    }
}