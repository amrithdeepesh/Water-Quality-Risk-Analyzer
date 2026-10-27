package com.waterquality.model;

public class User {
    private String username;
    private String password;
    private String userType;

    public User() {
        this("", "", "casual");
    }

    public User(String username, String password) {
        this(username, password, "casual");
    }

    public User(String username, String password, String userType) {
        this.username = username;
        this.password = password;
        this.userType = "property-owner".equals(userType) ? "property-owner" : "casual";
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getUserType() { return userType; }
    public void setUserType(String userType) {
        this.userType = "property-owner".equals(userType) ? "property-owner" : "casual";
    }

    public String getUserTypeLabel() {
        return "property-owner".equals(userType) ? "Property owner" : "Casual user";
    }

    public boolean isUsernameValid() {
        if (username == null) {
            return false;
        }
        String trimmed = username.trim();
        return trimmed.length() >= 3 && trimmed.length() <= 30 && trimmed.matches("^[a-zA-Z0-9_.-]+$");
    }

    public boolean isPasswordValid() {
        return password != null && password.length() >= 6 && password.length() <= 64;
    }

    public String toJson() {
        return "{\"username\":\"" + escapeJson(username) + "\","
                + "\"userType\":\"" + escapeJson(userType) + "\","
                + "\"role\":\"" + escapeJson(getUserTypeLabel()) + "\"}";
    }

    public String toPrettyJson() {
        return "{\n"
                + "  \"username\": \"" + escapeJson(username) + "\",\n"
                + "  \"userType\": \"" + escapeJson(userType) + "\",\n"
                + "  \"role\": \"" + escapeJson(getUserTypeLabel()) + "\"\n"
                + "}";
    }

    private String escapeJson(String text) {
        if (text == null) {
            return "";
        }
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < text.length(); i++) {
            char ch = text.charAt(i);
            switch (ch) {
                case '\\': builder.append("\\\\"); break;
                case '\"': builder.append("\\\""); break;
                case '\b': builder.append("\\b"); break;
                case '\f': builder.append("\\f"); break;
                case '\n': builder.append("\\n"); break;
                case '\r': builder.append("\\r"); break;
                case '\t': builder.append("\\t"); break;
                default:
                    if (ch < ' ') {
                        builder.append(String.format("\\u%04x", (int) ch));
                    } else {
                        builder.append(ch);
                    }
                    break;
            }
        }
        return builder.toString();
    }
}
