package com.waterquality.service;

import com.waterquality.model.User;

public class UserService implements UserOperations {

    @Override
    public boolean validateUser(User user) {

        if (user.isUsernameValid() && user.isPasswordValid()) {
            return true;
        }

        return false;
    }

}