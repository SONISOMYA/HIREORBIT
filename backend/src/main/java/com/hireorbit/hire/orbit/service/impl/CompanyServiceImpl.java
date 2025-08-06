package com.hireorbit.hire.orbit.service.impl;

import com.hireorbit.hire.orbit.entity.Company;
import com.hireorbit.hire.orbit.repository.CompanyRepository;
import com.hireorbit.hire.orbit.service.CompanyService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CompanyServiceImpl implements CompanyService {

    private final CompanyRepository companyRepository;

    @Override
    public List<String> searchByPrefix(String prefix) {
        return companyRepository.findByNameStartingWithIgnoreCase(prefix)
                .stream()
                .map(Company::getName)
                .collect(Collectors.toList());
    }

    @Override
    public void saveAll(List<Company> companies) {
        companyRepository.saveAll(companies);
    }
}