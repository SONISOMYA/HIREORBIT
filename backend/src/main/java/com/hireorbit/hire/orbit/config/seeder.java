package com.hireorbit.hire.orbit.config;

import com.hireorbit.hire.orbit.entity.Company;
import com.hireorbit.hire.orbit.repository.CompanyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class seeder implements CommandLineRunner {

    private final CompanyRepository companyRepository;

    @Override
    public void run(String... args) throws Exception {
        if (companyRepository.count() == 0) {
            List<String> companyNames = List.of(
                    "Amazon", "Google", "Microsoft", "Meta", "Netflix", "Apple", "Adobe", "Salesforce",
                    "Oracle", "SAP", "IBM", "Intel", "Nvidia", "Dell", "HP", "Cisco", "Zoom",
                    "LinkedIn", "Twitter", "Reddit", "GitHub", "Dropbox", "Slack", "Notion",
                    "Atlassian", "Spotify", "Airbnb", "Uber", "Lyft", "Stripe", "Square", "PayPal",
                    "Visa", "MasterCard", "Goldman Sachs", "JPMorgan", "Barclays", "Morgan Stanley",
                    "TCS", "Infosys", "Wipro", "HCLTech", "Tech Mahindra", "Capgemini", "Cognizant",
                    "Zoho", "Freshworks", "BrowserStack", "Postman", "CRED", "Razorpay", "Unacademy",
                    "UpGrad", "BYJU'S", "Swiggy", "Zomato", "Flipkart", "Myntra", "Snapdeal",
                    "Ola", "PhonePe", "Paytm", "Groww", "Zerodha", "Tata 1mg", "Tata Digital",
                    "Lenskart", "Boat", "Mamaearth", "Nykaa", "Meesho", "Udaan", "InMobi", "ShareChat",
                    "Gojek", "BigBasket", "Jio Platforms", "Reliance Retail", "Delhivery", "Dunzo",
                    "Instamojo", "Cleartax", "Smallcase", "Niyo", "Open Financial", "Slice", "Turing",
                    "InVideo", "Scaler", "InterviewBit", "Coding Ninjas", "CodeChef", "GeeksforGeeks",
                    "Hackerrank", "Leetcode", "Replit", "Toppr", "Vedantu", "WhiteHat Jr"
            );

            List<Company> companies = companyNames.stream()
                    .map(name -> Company.builder().name(name).build())
                    .toList();

            companyRepository.saveAll(companies);
            System.out.println("✅ CompanySeeder: Inserted " + companies.size() + " default companies.");
        } else {
            System.out.println("ℹ️ CompanySeeder: Companies already exist.");
        }
    }
}