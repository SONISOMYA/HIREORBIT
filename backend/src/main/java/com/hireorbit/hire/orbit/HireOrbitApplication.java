package com.hireorbit.hire.orbit;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling // Enables cron-based tasks
public class HireOrbitApplication {
	public static void main(String[] args) {
		SpringApplication.run(HireOrbitApplication.class, args);
	}
}