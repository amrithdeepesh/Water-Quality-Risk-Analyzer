package com.waterquality.service;

import com.waterquality.exception.InvalidUserInputException;
import com.waterquality.model.User;

public interface UserOperations {

    boolean validateUser(User user) throws InvalidUserInputException;

    boolean register(User user) throws InvalidUserInputException;

    boolean authenticate(String username, String password);
}