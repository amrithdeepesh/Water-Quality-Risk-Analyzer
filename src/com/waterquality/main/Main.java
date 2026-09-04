package com.waterquality.main;

import com.waterquality.model.User;

public class Main {

    public static void main(String[] args) {

        User user1 = new User("Amrith", "1254446");

        System.out.println("User Details:");
        System.out.println("Username: " + user1.getUsername());

        System.out.println();

        System.out.println("Username Validation: " + user1.isUsernameValid());

        System.out.println("Password Validation: " + user1.isPasswordValid());

        System.out.println();

        if (user1.isUsernameValid() && user1.isPasswordValid()) {
            System.out.println("Result: User details are valid.");
        } else {
            System.out.println("Result: User details are invalid.");
        }
    }
}