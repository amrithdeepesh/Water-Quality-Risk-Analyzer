<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Water Quality Risk Analyzer</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <main class="page-container">
        <section class="form-card">
            <a class="brand"
               href="<%= request.getContextPath() %>/index.html">
                Water Quality Risk Analyzer
            </a>

            <h1>Your dashboard</h1>
            <p class="form-description">
                You are logged in. This page is protected by your session.
            </p>

            <form action="<%= request.getContextPath() %>/logout"
                  method="post">
                <button type="submit" class="button">Log out</button>
            </form>
        </section>
    </main>
</body>
</html>