package com.waterquality.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.waterquality.model.User;
import com.waterquality.repository.UserRepository;
import com.waterquality.exception.RepositoryException;
import com.waterquality.service.UserOperations;
import com.waterquality.service.UserService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.html");
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserOperations userService = new UserService();
        String appPath = request.getContextPath();

        try {
            if (userService.authenticate(username, password)) {
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) {
                    oldSession.invalidate();
                }
                HttpSession session = request.getSession(true);
                session.setAttribute("username", username.trim());
                User authenticatedUser = UserRepository.findByUsername(username);
                String userType = (authenticatedUser != null) ? authenticatedUser.getUserType() : "casual";
                session.setAttribute("userType", userType);
                response.sendRedirect(appPath + "/dashboard");
            } else {
                response.sendRedirect(
                        appPath + "/login.html?error=invalid-credentials");
            }
        } catch (RepositoryException exception) {
            getServletContext().log("Login failed while checking the account.", exception);
            response.sendRedirect(appPath + "/login.html?error=database-unavailable");
        }
    }
}