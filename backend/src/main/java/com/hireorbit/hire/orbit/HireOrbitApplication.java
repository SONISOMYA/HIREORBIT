package com.hireorbit.hire.orbit;

import com.hireorbit.hire.orbit.entity.User;
import com.hireorbit.hire.orbit.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
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
			user.setPassword(passwordEncoder.encode("admin123")); // ✅ encode!
			user.setRole("ADMIN");
		}
	}

	public static void main(String[] args) {
		SpringApplication.run(HireOrbitApplication.class, args);
		System.out.println(new BCryptPasswordEncoder().matches("admin123",
				"$2a$10$2Q0FevxXK2i1ccs3vTHkkOMAazFEYuykgcqCiwLX1A.KzwhRGZJ7S"));

	}


}