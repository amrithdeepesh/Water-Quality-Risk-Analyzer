<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.waterquality.model.WaterAnalysisResult" %>
<%@ page import="com.waterquality.model.WaterSample" %>
<%@ page import="com.waterquality.model.ParameterAssessment" %>
<%@ page import="java.util.List" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<%
    WaterAnalysisResult analysis =
            (WaterAnalysisResult) request.getAttribute("analysis");
    if (analysis == null) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }
    WaterSample sample = analysis.getSample();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analysis Result | Water Quality Risk Analyzer</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
    <main class="page-container">
        <section class="dashboard-card result-card">
            <header class="dashboard-header">
                <a class="brand" href="<%= request.getContextPath() %>/dashboard">Water Quality Risk Analyzer</a>
                <form action="<%= request.getContextPath() %>/logout" method="post">
                    <button type="submit" class="button button-secondary logout-button">Log out</button>
                </form>
            </header>
            <h1>Water sample analysis</h1>
            <p class="form-description">
                <%= escapeHtml(sample.getCity()) %>, <%= escapeHtml(sample.getState()) %>
                · <%= escapeHtml(sample.getWaterSource()) %>
                · Collected <%= escapeHtml(sample.getCollectionDate()) %>
            </p>
            <section class="score-card <%= analysis.getRiskCssClass() %>" aria-label="Overall risk result">
                <p class="score-label">Project risk score</p>
                <p class="score-value"><%= analysis.getRiskScore() %><span>/100</span></p>
                <p class="risk-level">Overall risk: <strong><%= escapeHtml(analysis.getRiskLevel()) %></strong></p>
            </section>
            <h2>Parameter results</h2>
            <div class="table-wrap">
                <table class="results-table">
                    <thead>
                        <tr><th>Parameter</th><th>Measured value</th><th>Status</th><th>Recommendation</th></tr>
                    </thead>
                    <tbody>
                        <%
                            List<ParameterAssessment> assessments = analysis.getAssessments();
                            for (ParameterAssessment item : assessments) {
                        %>
                        <tr>
                            <th scope="row"><%= escapeHtml(item.getName()) %></th>
                            <td><%= escapeHtml(item.getValue()) %></td>
                            <td><span class="status-pill <%= item.getStatusCssClass() %>"><%= escapeHtml(item.getStatus()) %></span></td>
                            <td><%= escapeHtml(item.getRecommendation()) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <p class="disclaimer">
                This is an educational estimate, not a laboratory result or a drinking-water safety certification.
                The simple score bands are project logic. Some reference values follow
                <a href="https://www.bis.gov.in/other/DrinWatIS10500.pdf" target="_blank" rel="noopener">BIS IS 10500</a>;
                dissolved oxygen and temperature are contextual indicators here.
            </p>
            <a class="button analyze-button" href="<%= request.getContextPath() %>/dashboard">Analyze another sample</a>
        </section>
    </main>
</body>
</html>
