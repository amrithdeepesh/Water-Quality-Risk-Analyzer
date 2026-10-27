package com.waterquality.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class Database {
    private static final String DEFAULT_URL =
            "jdbc:mysql://127.0.0.1:3306/water_quality_analyzer"
            + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private Database() { }

    public static boolean isConfigured() {
        return hasValue("WQ_DB_USER") && hasValue("WQ_DB_PASSWORD");
    }

    public static Connection getConnection() throws SQLException {
        if (!isConfigured()) {
            throw new SQLException(
                    "MySQL is not configured. Set WQ_DB_USER and WQ_DB_PASSWORD.");
        }
        String url = System.getenv("WQ_DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = DEFAULT_URL;
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException exception) {
            throw new SQLException(
                    "MySQL Connector/J is missing from WEB-INF/lib.", exception);
        }
        return DriverManager.getConnection(url, System.getenv("WQ_DB_USER"),
                System.getenv("WQ_DB_PASSWORD"));
    }

    private static boolean hasValue(String name) {
        String value = System.getenv(name);
        return value != null && !value.trim().isEmpty();
    }
}
