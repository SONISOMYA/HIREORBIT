package com.hireorbit.hire.orbit;

import com.hireorbit.hire.orbit.entity.User;
import com.hireorbit.hire.orbit.repository.UserRepository;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling // ✅ Enables cron-based tasks
public class HireOrbitApplication implements CommandLineRunner {

	private final UserRepository userRepository;
	private final PasswordEncoder passwordEncoder;

	public HireOrbitApplication(UserRepository userRepository, PasswordEncoder passwordEncoder) {
		this.userRepository = userRepository;
		this.passwordEncoder = passwordEncoder;
	}

	@Override
	public void run(String... args) throws Exception {
		if (!userRepository.existsByUsername("admin")) {
			User user = new User();
			user.setUsername("admin");
			user.setPassword(passwordEncoder.encode("admin123"));
			user.setRole("ADMIN");
			userRepository.save(user);
			System.out.println("✅ Admin user created");
		}
	}

	public static void main(String[] args) {
		SpringApplication.run(HireOrbitApplication.class, args);
	}
}