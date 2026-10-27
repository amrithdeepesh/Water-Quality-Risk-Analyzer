package com.waterquality.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.waterquality.model.User;
import com.waterquality.repository.UserRepository;
@WebServlet({"/user-profile", "/user-data"})
public class UserDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (session == null || session.getAttribute("username") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\":\"login-required\",\"authenticated\":false}");
            out.flush();
            return;
        }

        String username = (String) session.getAttribute("username");
        User user = UserRepository.findByUsername(username);

        if (user == null) {
            String userType = (String) session.getAttribute("userType");
            user = new User(username, null, userType);
        }

        out.write(user.toPrettyJson());
        out.flush();
    }
}
