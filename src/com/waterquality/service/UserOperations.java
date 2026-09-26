package com.waterquality.service;

import com.waterquality.model.User;
import com.waterquality.exception.InvalidUserInputException;

public interface UserOperations {

    boolean validateUser(User user) throws InvalidUserInputException;

    boolean authenticate(String username, String password);
}
