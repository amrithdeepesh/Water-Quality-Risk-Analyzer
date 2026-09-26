package com.waterquality.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.waterquality.service.UserOperations;
import com.waterquality.service.UserService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserOperations userService = new UserService();
        String appPath = request.getContextPath();

        if (userService.authenticate(username, password)) {
            HttpSession oldSession = request.getSession(false);

            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("username", username.trim());

            response.sendRedirect(appPath + "/dashboard");
        } else {
            response.sendRedirect(
                    appPath + "/login.html?error=invalid-credentials");
        }
    }
}