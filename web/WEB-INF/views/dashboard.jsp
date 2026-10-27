<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Water Analysis | Water Quality Risk Analyzer</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css?v=20261012-water-theme-3">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" defer></script>
    <script src="<%= request.getContextPath() %>/js/location-picker.js?v=20261012-pincode" defer></script>
    <script src="<%= request.getContextPath() %>/js/analysis.js?v=20261012-pincode" defer></script>
</head>
<body>
    <main class="page-container">
        <section class="dashboard-card">
            <header class="dashboard-header">
                <a class="brand" href="<%= request.getContextPath() %>/index.html">
                    Water Quality Risk Analyzer
                </a>
                <form action="<%= request.getContextPath() %>/logout" method="post">
                    <button type="submit" class="button button-secondary logout-button">Log out</button>
                </form>
            </header>
            <nav class="dashboard-nav" aria-label="Dashboard navigation">
                <a class="nav-current" href="<%= request.getContextPath() %>/dashboard">Overview</a>
                <a href="#analysis-form">Analyze sample</a>
                <a href="<%= request.getContextPath() %>/map">Regional map</a>
            </nav>
            <section class="welcome-banner">
                <div>
                    <p class="eyebrow">Your dashboard</p>
                    <h1>Welcome, <%= escapeHtml((String) session.getAttribute("username")) %></h1>
                    <p class="form-description">Your water checks, all in one place.</p>
                </div>
                <span class="role-badge"><%= "property-owner".equals(session.getAttribute("userType")) ? "Property owner" : "Casual user" %></span>
            </section>
            <section class="role-guidance">
                <% if ("property-owner".equals(session.getAttribute("userType"))) { %>
                    <strong>Property owner portal</strong>
                    <p>Monitor and track water quality across your property. Enter lab or test kit readings to get real-time safety assessments.</p>
                <% } else { %>
                    <strong>Household & community portal</strong>
                    <p>Test drinking water, tap water, or local well water samples with instant health and safety ratings.</p>
                <% } %>
            </section>
            <section class="dashboard-summary">
                <article><span class="summary-icon">01</span><div><strong>Start a water check</strong><p>Enter results from a water test kit or lab.</p></div></article>
                <article><span class="summary-icon">02</span><div><strong>Understand the result</strong><p>See risk bands and a note for each measure.</p></div></article>
                <article><span class="summary-icon">03</span><div><strong>Explore local patterns</strong><p>Browse mapped water safety reports and verified samples.</p></div></article>
            </section>
            <section class="map-preview" id="regional-map">
                <div>
                    <p class="eyebrow">Interactive regional map</p>
                    <h2>Explore sample locations across India</h2>
                    <p>Filter water test samples by risk level, source type, and collection date across registered locations.</p>
                    <a class="button button-secondary map-open-button" href="<%= request.getContextPath() %>/map">Open the interactive map</a>
                </div>
                <div class="map-legend" aria-label="Map color legend">
                    <span><i class="legend-dot safe-dot"></i>Lower risk</span>
                    <span><i class="legend-dot moderate-dot"></i>Moderate</span>
                    <span><i class="legend-dot high-dot"></i>High</span>
                    <span><i class="legend-dot critical-dot"></i>Critical</span>
                </div>
                <p class="map-note">Markers indicate tested samples across registered monitoring stations and community reports.</p>
            </section>
            <h2 class="section-heading" id="recent-activity">New sample analysis</h2>
            <p class="form-description">Enter laboratory or field-test values, add your 6-digit PIN code, then choose the actual sampling point on the map. A postal PIN only identifies a broader area.</p>
            <% if (request.getAttribute("analysisError") != null) { %>
                <p class="form-message error" role="alert"><%= request.getAttribute("analysisError") %></p>
            <% } %>
            <div class="scenario-panel" aria-labelledby="scenario-title">
                <h2 id="scenario-title">Quick test presets</h2>
                <div class="scenario-buttons" id="scenario-buttons" data-scenarios="<%= request.getContextPath() %>/data/sample-scenarios.json">
                </div>
                <p class="helper-text" id="scenario-message" aria-live="polite"></p>
            </div>
            <form id="analysis-form" action="<%= request.getContextPath() %>/analyze" method="post">
                <fieldset>
                    <legend>Sample details</legend>
                    <div class="analysis-grid">
                        <div class="form-group">
                            <label for="state">State or union territory</label>
                            <select id="state" name="state" required>
                                <option value="">Choose a state or UT</option>
                                <option>Andhra Pradesh</option><option>Arunachal Pradesh</option>
                                <option>Assam</option><option>Bihar</option><option>Chandigarh</option>
                                <option>Chhattisgarh</option><option>Dadra and Nagar Haveli and Daman and Diu</option>
                                <option>Delhi</option><option>Goa</option><option>Gujarat</option>
                                <option>Haryana</option><option>Himachal Pradesh</option><option>Jammu and Kashmir</option>
                                <option>Jharkhand</option><option>Karnataka</option><option>Kerala</option>
                                <option>Ladakh</option><option>Lakshadweep</option><option>Madhya Pradesh</option>
                                <option>Maharashtra</option><option>Manipur</option><option>Meghalaya</option>
                                <option>Mizoram</option><option>Nagaland</option><option>Odisha</option>
                                <option>Puducherry</option><option>Punjab</option><option>Rajasthan</option>
                                <option>Sikkim</option><option>Tamil Nadu</option><option>Telangana</option>
                                <option>Tripura</option><option>Uttar Pradesh</option><option>Uttarakhand</option>
                                <option>West Bengal</option><option>Andaman and Nicobar Islands</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="city">District or city</label>
                            <input id="city" name="city" maxlength="100" required>
                        </div>
                        <div class="form-group">
                            <label for="waterSource">Water source</label>
                            <select id="waterSource" name="waterSource" required>
                                <option value="">Choose a source</option>
                                <option>Tap Water</option>
                                <option>Borewell</option>
                                <option>River</option>
                                <option>Lake</option>
                                <option>Well</option>
                                <option>Spring</option>
                                <option>Reservoir</option>
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="collectionDate">Sample collection date</label>
                            <input id="collectionDate" name="collectionDate" type="date" required>
                        </div>
                    </div>
                    <div class="location-panel">
                        <div class="location-heading">
                            <div>
                                <strong>Sampling location & map point</strong>
                                <p>Enter your 6-digit PIN code to locate your area, or use your device GPS. Then click or drag the marker to your exact tap/well point.</p>
                            </div>
                            <button id="use-current-location" class="button button-secondary location-button" type="button">Use my current location</button>
                        </div>
                        <p id="pin-status" class="helper-text" role="status" aria-live="polite">Enter your 6-digit PIN code to locate your area, then click the map to select the exact water point.</p>
                        <div id="sample-location-map" class="sample-location-map" role="application" aria-label="Choose the exact water sampling point on the map" data-pincode-dataset="<%= request.getContextPath() %>/data/india-pincode-offices.json"></div>
                        <p class="helper-text">Click the map to place the marker at the water source. PIN and post-office coordinates are approximate area references only.</p>
                        <div class="analysis-grid location-grid">
                            <div class="form-group">
                                <label for="latitude">Latitude</label>
                                <input id="latitude" name="latitude" type="number" min="6" max="38" step="0.000001" placeholder="e.g. 12.971600" required>
                            </div>
                            <div class="form-group">
                                <label for="longitude">Longitude</label>
                                <input id="longitude" name="longitude" type="number" min="68" max="98" step="0.000001" placeholder="e.g. 77.594600" required>
                            </div>
                        </div>
                        <p id="location-status" class="helper-text" role="status" aria-live="polite">Coordinates are saved with your analysis. On the map, they are shown only if you choose to share this sample.</p>
                    </div>
                    <label class="share-map-option">
                        <input type="checkbox" name="includeOnMap" value="true">
                        Share this sample and its exact map location anonymously (visible to map visitors)
                    </label>
                </fieldset>
                <fieldset>
                    <legend>Water parameters</legend>
                    <div class="analysis-grid">
                        <div class="form-group">
                            <label for="ph">pH (0–14)</label>
                            <input id="ph" name="ph" type="number" min="0" max="14" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label for="turbidity">Turbidity (NTU)</label>
                            <input id="turbidity" name="turbidity" type="number" min="0" max="1000" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label for="tds">Total dissolved solids (mg/L)</label>
                            <input id="tds" name="tds" type="number" min="0" max="20000" step="0.1" required>
                        </div>
                        <div class="form-group">
                            <label for="dissolvedOxygen">Dissolved oxygen (mg/L)</label>
                            <input id="dissolvedOxygen" name="dissolvedOxygen" type="number" min="0" max="30" step="0.1" required>
                        </div>
                        <div class="form-group">
                            <label for="temperature">Temperature (°C)</label>
                            <input id="temperature" name="temperature" type="number" min="-10" max="100" step="0.1" required>
                        </div>
                        <div class="form-group">
                            <label for="hardness">Total hardness (mg/L as CaCO3)</label>
                            <input id="hardness" name="hardness" type="number" min="0" max="5000" step="0.1" required>
                        </div>
                        <div class="form-group">
                            <label for="freeChlorine">Free residual chlorine (mg/L)</label>
                            <input id="freeChlorine" name="freeChlorine" type="number" min="0" max="10" step="0.01" required>
                        </div>
                        <div class="form-group">
                            <label for="coliformDetected">Coliform indicator</label>
                            <select id="coliformDetected" name="coliformDetected" required>
                                <option value="">Choose a result</option>
                                <option value="false">Not detected</option>
                                <option value="true">Detected</option>
                            </select>
                        </div>
                    </div>
                </fieldset>
                <button type="submit" class="button analyze-button">Analyze sample</button>
            </form>
            <p class="disclaimer">Educational demonstration only. This rule-based estimate is not a laboratory test or a drinking-water safety certification.</p>
        </section>
    </main>
</body>
</html>
