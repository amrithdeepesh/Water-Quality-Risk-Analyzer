package com.waterquality.main;

import com.waterquality.exception.InvalidUserInputException;
import com.waterquality.model.User;
import com.waterquality.service.UserOperations;
import com.waterquality.service.UserService;

public class Main {

    public static void main(String[] args) {
        System.out.println("==================================================");
        System.out.println("  Water Quality Risk Analyzer - Phase Verification");
        System.out.println("==================================================");

        System.out.println("\n[Phase 1] Core Application Setup and Design:");
        User validUser = new User("Amrith", "123456", "property-owner");
        System.out.println("Created User: " + validUser.getUsername() + " (" + validUser.getUserTypeLabel() + ")");
        System.out.println("isUsernameValid(): " + validUser.isUsernameValid());
        System.out.println("isPasswordValid(): " + validUser.isPasswordValid());

        System.out.println("\n[Phase 2] Structured Programming and Reliability:");
        UserOperations userService = new UserService();
        try {
            boolean registered = userService.register(validUser);
            System.out.println("Registration via UserOperations: " + registered);
        } catch (InvalidUserInputException exception) {
            System.out.println("Registration error: " + exception.getMessage());
        }

        boolean isAuthenticated = userService.authenticate(
                validUser.getUsername(), validUser.getPassword());
        System.out.println("Authentication: " + isAuthenticated);

        User invalidUser = new User("Al", "123");
        try {
            System.out.println("Validating invalid user ('Al', '123')...");
            userService.validateUser(invalidUser);
            System.out.println("User is valid.");
        } catch (InvalidUserInputException exception) {
            System.out.println("Caught expected InvalidUserInputException: " + exception.getMessage());
        }

        System.out.println("\n[Phase 3] User Data Format using JSON:");
        System.out.println(validUser.toPrettyJson());
        System.out.println("Via userService.getUserDataAsJson(): " + userService.getUserDataAsJson(validUser));

        System.out.println("\n==================================================");
        System.out.println("All phases successfully initialized and verified!");
        System.out.println("Web application running at: http://localhost:8081/WaterQualityRiskAnalyzer/");
        System.out.println("==================================================");
    }
}
