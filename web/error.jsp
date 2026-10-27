<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notice | Water Quality Risk Analyzer</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261012-water-theme-2">
</head>
<body>
    <main class="page-container">
        <section class="form-card" style="max-width: 540px; text-align: center;">
            <a class="brand" href="<%= request.getContextPath() %>/index.html">Water Quality Risk Analyzer</a>
            <h1 style="margin-top: 1.5rem;">Page or Resource Notice</h1>
            <p class="form-description">
                <% 
                    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
                    if (statusCode != null && statusCode == 404) {
                %>
                    The page or resource you requested could not be found.
                <% } else { %>
                    An unexpected condition occurred while processing your request. Please return to the homepage or login again.
                <% } %>
            </p>
            <div style="margin-top: 2rem; display: flex; gap: 1rem; justify-content: center;">
                <a class="button" href="<%= request.getContextPath() %>/index.html">Return Home</a>
                <a class="button button-secondary" href="<%= request.getContextPath() %>/login.html">Login</a>
            </div>
        </section>
    </main>
</body>
</html>
