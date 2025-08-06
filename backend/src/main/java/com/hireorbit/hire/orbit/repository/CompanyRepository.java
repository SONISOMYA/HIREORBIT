package com.hireorbit.hire.orbit.repository;

import com.hireorbit.hire.orbit.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CompanyRepository extends JpaRepository<Company, Long> {
    List<Company> findByNameStartingWithIgnoreCase(String prefix);
}