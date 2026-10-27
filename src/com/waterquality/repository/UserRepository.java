package com.waterquality.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Locale;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import com.waterquality.config.Database;
import com.waterquality.exception.RepositoryException;
import com.waterquality.model.User;
import com.waterquality.security.PasswordHasher;
public final class UserRepository {
    private static final ConcurrentMap<String, StoredUser> DEMO_USERS =
            new ConcurrentHashMap<String, StoredUser>();

    private UserRepository() { }

    public static boolean register(User user) {
        if (user == null || !user.isUsernameValid() || !user.isPasswordValid()) {
            return false;
        }
        String salt = PasswordHasher.newSalt();
        String hash = PasswordHasher.hash(user.getPassword(), salt);
        String type = user.getUserType();
        if (!Database.isConfigured()) {
            String key = normalize(user.getUsername());
            return DEMO_USERS.putIfAbsent(key,
                    new StoredUser(user.getUsername(), type, salt, hash)) == null;
        }
        String sql = "INSERT INTO users (username, password_salt, password_hash, user_type) VALUES (?, ?, ?, ?)";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getUsername().trim());
            statement.setString(2, salt);
            statement.setString(3, hash);
            statement.setString(4, type);
            return statement.executeUpdate() == 1;
        } catch (SQLException exception) {
            if ("23000".equals(exception.getSQLState())) {
                return false;
            }
            throw new RepositoryException("Could not save the account to MySQL.", exception);
        }
    }

    public static User findByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        if (!Database.isConfigured()) {
            StoredUser saved = DEMO_USERS.get(normalize(username));
            return saved == null ? null : new User(saved.username, null, saved.userType);
        }
        String sql = "SELECT username, user_type FROM users WHERE username = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username.trim());
            try (ResultSet result = statement.executeQuery()) {
                return result.next()
                        ? new User(result.getString("username"), null,
                                result.getString("user_type"))
                        : null;
            }
        } catch (SQLException exception) {
            throw new RepositoryException("Could not read the account from MySQL.", exception);
        }
    }

    public static boolean authenticate(String username, String password) {
        if (username == null || password == null) {
            return false;
        }
        if (!Database.isConfigured()) {
            StoredUser saved = DEMO_USERS.get(normalize(username));
            return saved != null
                    && PasswordHasher.matches(password, saved.salt, saved.passwordHash);
        }
        String sql = "SELECT password_salt, password_hash FROM users WHERE username = ?";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username.trim());
            try (ResultSet result = statement.executeQuery()) {
                return result.next() && PasswordHasher.matches(password,
                        result.getString("password_salt"),
                        result.getString("password_hash"));
            }
        } catch (SQLException exception) {
            throw new RepositoryException("Could not verify the account with MySQL.", exception);
        }
    }

    private static String normalize(String username) {
        return username.trim().toLowerCase(Locale.ROOT);
    }

    private static final class StoredUser {
        private final String username;
        private final String userType;
        private final String salt;
        private final String passwordHash;
        private StoredUser(String username, String userType, String salt,
                String passwordHash) {
            this.username = username;
            this.userType = userType;
            this.salt = salt;
            this.passwordHash = passwordHash;
        }
    }
}
