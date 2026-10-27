package com.waterquality.servlet;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.waterquality.config.Database;
import com.waterquality.exception.RepositoryException;
import com.waterquality.model.WaterAnalysisResult;
import com.waterquality.model.WaterSample;
import com.waterquality.repository.WaterSampleRepository;
import com.waterquality.service.WaterAnalysisOperations;
import com.waterquality.service.WaterQualityAnalyzer;

@WebServlet("/analyze")
public class WaterAnalysisServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String appPath = request.getContextPath();
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(appPath + "/login.html?error=login-required");
            return;
        }
        request.setCharacterEncoding("UTF-8");
        try {
            WaterSample sample = readSample(request);
            request.setAttribute("pincode", request.getParameter("pincode"));
            WaterAnalysisOperations analyzer = new WaterQualityAnalyzer();
            WaterAnalysisResult analysis = analyzer.analyze(sample);
            request.setAttribute("analysis", analysis);
            if (Database.isConfigured()) {
                try {
                    WaterSampleRepository.save(
                            (String) session.getAttribute("username"),
                            analysis,
                            "true".equals(request.getParameter("includeOnMap")));
                } catch (RepositoryException exception) {
                    request.setAttribute("storageWarning",
                            "The result is ready, but could not be saved to MySQL.");
                }
            } else {
                request.setAttribute("storageWarning",
                        "Demo mode: results are not saved. Configure MySQL to keep your history.");
            }
            request.getRequestDispatcher(
                    "/WEB-INF/views/analysis-result.jsp")
                    .forward(request, response);
        } catch (IllegalArgumentException exception) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            request.setAttribute("analysisError",
                    "Check the sample details and enter values in the allowed ranges.");
            request.getRequestDispatcher(
                    "/WEB-INF/views/dashboard.jsp")
                    .forward(request, response);
        }
    }

    private WaterSample readSample(HttpServletRequest request) {
        String state = requiredText(request, "state", 80);
        String city = requiredText(request, "city", 100);
        String pincode = request.getParameter("pincode");
        if (pincode != null && !pincode.trim().isEmpty()) {
            pincode = pincode.trim();
            if (!pincode.matches("[1-9][0-9]{5}")) {
                throw new IllegalArgumentException("Enter a valid six-digit Indian PIN code.");
            }
        }
        String source = requiredText(request, "waterSource", 30);
        if (!source.equals("Tap Water") && !source.equals("Borewell")
                && !source.equals("River") && !source.equals("Lake")
                && !source.equals("Well") && !source.equals("Spring")
                && !source.equals("Reservoir") && !source.equals("Other")) {
            throw new IllegalArgumentException("Invalid water source.");
        }
        String date = requiredText(request, "collectionDate", 10);
        try {
            LocalDate.parse(date);
        } catch (RuntimeException exception) {
            throw new IllegalArgumentException("Invalid collection date.");
        }
        String bacteria = request.getParameter("coliformDetected");
        if (!"true".equals(bacteria) && !"false".equals(bacteria)) {
            throw new IllegalArgumentException("Select a bacteria indicator.");
        }
        double latitude = number(request, "latitude", 6, 38);
        double longitude = number(request, "longitude", 68, 98);
        return new WaterSample(state, city, source, date, latitude, longitude,
                number(request, "ph", 0, 14),
                number(request, "turbidity", 0, 1000),
                number(request, "tds", 0, 20000),
                number(request, "dissolvedOxygen", 0, 30),
                number(request, "temperature", -10, 100),
                number(request, "hardness", 0, 5000),
                number(request, "freeChlorine", 0, 10),
                Boolean.parseBoolean(bacteria));
    }

    private String requiredText(HttpServletRequest request, String name,
            int maxLength) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()
                || value.trim().length() > maxLength) {
            throw new IllegalArgumentException("Missing or long field.");
        }
        return value.trim();
    }

    private double number(HttpServletRequest request, String name,
            double minimum, double maximum) {
        String raw = request.getParameter(name);
        if (raw == null || raw.trim().isEmpty()) {
            throw new IllegalArgumentException("Missing number.");
        }
        try {
            double value = Double.parseDouble(raw);
            if (Double.isNaN(value) || Double.isInfinite(value)
                    || value < minimum || value > maximum) {
                throw new IllegalArgumentException("Out of range.");
            }
            return value;
        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException("Invalid number.");
        }
    }
}
