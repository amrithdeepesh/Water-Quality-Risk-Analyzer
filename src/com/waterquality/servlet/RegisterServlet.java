package com.waterquality.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.waterquality.exception.InvalidUserInputException;
import com.waterquality.model.User;
import com.waterquality.service.UserOperations;
import com.waterquality.service.UserService;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String appPath = request.getContextPath();

        if (password == null || !password.equals(confirmPassword)) {
            response.sendRedirect(
                    appPath + "/register.html?error=password-mismatch");
            return;
        }

        User user = new User(
                username == null ? null : username.trim(),
                password);

        UserOperations userService = new UserService();

        try {
            boolean registered = userService.register(user);

            if (registered) {
                response.sendRedirect(appPath + "/login.html?registered=1");
            } else {
                response.sendRedirect(
                        appPath + "/register.html?error=duplicate");
            }
        } catch (InvalidUserInputException exception) {
            response.sendRedirect(
                    appPath + "/register.html?error=invalid");
        }
    }
}