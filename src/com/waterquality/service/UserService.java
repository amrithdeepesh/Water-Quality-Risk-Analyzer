package com.waterquality.service;

import com.waterquality.exception.InvalidUserInputException;
import com.waterquality.model.User;
import com.waterquality.repository.UserRepository;

public class UserService implements UserOperations {

    @Override
    public boolean validateUser(User user) throws InvalidUserInputException {
        if (user == null) {
            throw new InvalidUserInputException("User details cannot be null.");
        }

        if (!user.isUsernameValid()) {
            throw new InvalidUserInputException(
                    "Invalid username. Username must contain 3-30 alphanumeric characters, dots, hyphens, or underscores.");
        }

        if (!user.isPasswordValid()) {
            throw new InvalidUserInputException(
                    "Invalid password. Password must contain between 6 and 64 characters.");
        }

        return true;
    }

    @Override
    public boolean register(User user) throws InvalidUserInputException {
        validateUser(user);
        return UserRepository.register(user);
    }

    @Override
    public boolean authenticate(String username, String password) {
        return UserRepository.authenticate(username, password);
    }

    @Override
    public String getUserDataAsJson(User user) {
        return user == null ? "{}" : user.toJson();
    }
}