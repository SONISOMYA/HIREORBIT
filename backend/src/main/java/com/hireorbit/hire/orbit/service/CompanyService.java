package com.hireorbit.hire.orbit.service;

import com.hireorbit.hire.orbit.entity.Company;

import java.util.List;

public interface CompanyService {
    List<String> searchByPrefix(String prefix);
    void saveAll(List<Company> companies);
}