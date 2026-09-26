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
                    "Invalid username. Username must contain at least 3 characters.");
        }

        if (!user.isPasswordValid()) {
            throw new InvalidUserInputException(
                    "Invalid password. Password must contain at least 6 characters.");
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
        User savedUser = UserRepository.findByUsername(username);

        return savedUser != null
                && savedUser.getPassword().equals(password);
    }
}