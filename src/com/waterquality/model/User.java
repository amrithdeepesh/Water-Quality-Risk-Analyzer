package com.waterquality.model;

public class User {
    private String username;
    private String password;
    private String userType;

    public User(String username, String password) {
        this(username, password, "casual");
    }

    public User(String username, String password, String userType) {
        this.username = username;
        this.password = password;
        this.userType = "property-owner".equals(userType) ? "property-owner" : "casual";
    }

    public String getUsername() { return username; }
    public String getPassword() { return password; }
    public String getUserType() { return userType; }
    public String getUserTypeLabel() {
        return "property-owner".equals(userType) ? "Property owner" : "Casual user";
    }

    public boolean isUsernameValid() {
        return username != null && username.trim().length() >= 3;
    }

    public boolean isPasswordValid() {
        return password != null && password.trim().length() >= 6;
    }
}
