package com.waterquality.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.waterquality.config.Database;
import com.waterquality.repository.WaterSampleRepository;

@WebServlet("/map-data")
public class MapDataServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setHeader("Cache-Control", "no-store");
        try {
            if (!Database.isConfigured()) {
                response.getWriter().write(readDemoData());
                return;
            }
            try {
                response.getWriter().write(
                        WaterSampleRepository.listPublicMapSamples());
            } catch (RuntimeException databaseError) {
                response.getWriter().write(readDemoData());
            }
        } catch (IOException exception) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE,
                    "Map sample data is unavailable.");
        }
    }

    private String readDemoData() throws IOException {
        InputStream stream = getServletContext()
                .getResourceAsStream("/data/map-samples.json");
        if (stream == null) {
            return "{\"source\":\"demo\",\"samples\":[]}";
        }
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(stream, StandardCharsets.UTF_8))) {
            StringBuilder samples = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                samples.append(line);
            }
            return "{\"source\":\"demo\",\"samples\":" + samples + "}";
        }
    }
}
