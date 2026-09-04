package com.waterquality.model;

public class User {
    private String username;
    private String password;

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public boolean isUsernameValid() {

        if (username == null || username.trim().isEmpty()) {
            return false;
        }

        if (username.length() < 3) {
            return false;
        }

        return true;
    }

    public boolean isPasswordValid() {

        if (password == null || password.trim().isEmpty()) {
            return false;
        }

        if (password.length() < 6) {
            return false;
        }

        return true;
    }

}