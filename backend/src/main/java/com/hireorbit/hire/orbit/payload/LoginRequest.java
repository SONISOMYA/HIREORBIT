package com.hireorbit.hire.orbit.payload;

import lombok.Data;

@Data
public class LoginRequest {
    private String username;
    private String password;
}