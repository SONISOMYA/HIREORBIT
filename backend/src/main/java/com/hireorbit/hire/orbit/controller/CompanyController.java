package com.hireorbit.hire.orbit.controller;

import com.hireorbit.hire.orbit.entity.Company;
import com.hireorbit.hire.orbit.service.CompanyService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/companies")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")

public class CompanyController {

    private final CompanyService companyService;

    @GetMapping("/search")
    public List<String> search(@RequestParam String prefix) {
        return companyService.searchByPrefix(prefix);
    }
}