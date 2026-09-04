package com.waterquality.service;

import com.waterquality.model.User;

public interface UserOperations {

    boolean validateUser(User user);

    boolean authenticate(String username, String password);
}