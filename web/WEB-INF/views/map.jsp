<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Regional Water Map | Water Quality Risk Analyzer</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261012-water-theme-2">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" defer></script>
    <script src="<%= request.getContextPath() %>/js/map.js?v=20261012-map-controls" defer></script>
</head>
<body class="map-body">
    <main class="page-container">
        <section class="dashboard-card map-page-card">
            <header class="dashboard-header">
                <a class="brand" href="<%= request.getContextPath() %>/dashboard">Water Quality Risk Analyzer</a>
                <div style="display: flex; gap: 0.75rem; align-items: center;">
                    <a class="button button-secondary map-back" href="<%= request.getContextPath() %>/dashboard">Back to dashboard</a>
                    <form action="<%= request.getContextPath() %>/logout" method="post" style="margin: 0;">
                        <button type="submit" class="button button-secondary logout-button">Log out</button>
                    </form>
                </div>
            </header>
            <section class="map-intro">
                <div>
                    <p class="eyebrow">Regional view · India</p>
                    <h1>Water sample risk map</h1>
                    <p class="form-description">Explore water quality samples by location, date, source, and risk assessment band. Drag to move; scroll or use +/− to zoom.</p>
                </div>
                <span id="map-source-badge" class="role-badge">Loading samples…</span>
            </section>
            <div class="map-toolbar">
                <label>Risk
                    <select id="risk-filter">
                        <option value="all">All risk levels</option>
                        <option value="safe">Lower</option>
                        <option value="moderate">Moderate</option>
                        <option value="high">High</option>
                        <option value="critical">Critical</option>
                    </select>
                </label>
                <label>Water source
                    <select id="source-filter"><option value="all">All sources</option></select>
                </label>
                <label>Time range
                    <select id="date-filter">
                        <option value="all">All dates</option>
                        <option value="7">Last 7 days</option>
                        <option value="30">Last 30 days</option>
                        <option value="90">Last 90 days</option>
                    </select>
                </label>
            </div>
            <div class="map-layout">
                <div id="india-water-map" role="application" aria-label="Interactive map of water sample risk in India"
                     data-endpoint="<%= request.getContextPath() %>/map-data"
                     data-fallback="<%= request.getContextPath() %>/data/map-samples.json"></div>
                <aside class="map-sidebar">
                    <div class="map-count"><span id="visible-count">0</span><small>samples shown</small></div>
                    <p id="map-message" class="map-message" role="status">Loading map samples…</p>
                    <div class="map-legend">
                        <span><i class="legend-dot safe-dot"></i>Lower risk</span>
                        <span><i class="legend-dot moderate-dot"></i>Moderate risk</span>
                        <span><i class="legend-dot high-dot"></i>High risk</span>
                        <span><i class="legend-dot critical-dot"></i>Critical risk</span>
                    </div>
                    <p class="map-disclaimer">Colored circles represent water quality ratings for tested samples based on standard parameters.</p>
                    <a class="button analyze-button" href="<%= request.getContextPath() %>/dashboard#analysis-form">Add a sample</a>
                </aside>
            </div>
        </section>
    </main>
</body>
</html>
