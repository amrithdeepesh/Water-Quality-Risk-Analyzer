package com.waterquality.repository;

import java.util.Locale;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import com.waterquality.model.User;

public final class UserRepository {

    private static final ConcurrentMap<String, User> USERS =
            new ConcurrentHashMap<String, User>();

    private UserRepository() {
    }

    public static boolean register(User user) {
        if (user == null || user.getUsername() == null
                || user.getUsername().trim().isEmpty()) {
            return false;
        }

        String key = normalize(user.getUsername());
        return USERS.putIfAbsent(key, user) == null;
    }

    public static User findByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }

        return USERS.get(normalize(username));
    }

    private static String normalize(String username) {
        return username.trim().toLowerCase(Locale.ROOT);
    }
}