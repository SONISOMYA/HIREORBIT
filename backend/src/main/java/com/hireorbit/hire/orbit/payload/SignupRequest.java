package com.hireorbit.hire.orbit.payload;

import lombok.Data;

@Data
public class SignupRequest {
    private String username;
    private String password;
}