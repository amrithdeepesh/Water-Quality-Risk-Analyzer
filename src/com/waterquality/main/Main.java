package com.waterquality.main;

import com.waterquality.exception.InvalidUserInputException;
import com.waterquality.model.User;
import com.waterquality.service.UserOperations;
import com.waterquality.service.UserService;

public class Main {

    public static void main(String[] args) {
        System.out.println("=== Water Quality Risk Analyzer - Phase 2 ===");

        User validUser = new User("Amrith", "123456");
        UserOperations userService = new UserService();

        System.out.println("\nRegistration:");
        try {
        boolean registered = userService.register(validUser);
        System.out.println("Registration successful: " + registered);
        } catch (InvalidUserInputException exception) {
        System.out.println("Registration error: " + exception.getMessage());
        }

        System.out.println("\nAuthentication:");
        boolean isAuthenticated = userService.authenticate(
                validUser.getUsername(), validUser.getPassword());
        System.out.println("Authentication successful: " + isAuthenticated);

        System.out.println("\nInvalid Input Handling:");
        User invalidUser = new User("Al", "123");
        try {
            userService.validateUser(invalidUser);
            System.out.println("User is valid.");
        } catch (InvalidUserInputException exception) {
            System.out.println("Validation error: " + exception.getMessage());
        }

        System.out.println("\nPhase 2 demonstration completed.");
    }
}
