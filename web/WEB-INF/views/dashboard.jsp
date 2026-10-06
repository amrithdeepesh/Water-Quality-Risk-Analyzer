<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Water Analysis | Water Quality Risk Analyzer</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <script src="<%= request.getContextPath() %>/js/analysis.js" defer></script>
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
                <a href="#regional-map">Regional map</a>
            </nav>
            <section class="welcome-banner">
                <div>
                    <p class="eyebrow">Your dashboard</p>
                    <h1>Welcome, <%= session.getAttribute("username") %></h1>
                    <p class="form-description">Your water checks, all in one place.</p>
                </div>
                <span class="role-badge"><%= "property-owner".equals(session.getAttribute("userType")) ? "Property owner" : "Casual user" %></span>
            </section>
            <section class="role-guidance">
                <% if ("property-owner".equals(session.getAttribute("userType"))) { %>
                    <strong>Property owner view</strong>
                    <p>Use this space to start checks for your property. Property profiles, multiple sample points, and reminders can be added in a later phase.</p>
                <% } else { %>
                    <strong>Casual user view</strong>
                    <p>Start with a single sample from your home, a visit, or another place. You can add a property profile later if you need one.</p>
                <% } %>
            </section>
            <section class="dashboard-summary">
                <article><span class="summary-icon">01</span><div><strong>Start a water check</strong><p>Enter results from a water test kit or lab.</p></div></article>
                <article><span class="summary-icon">02</span><div><strong>Understand the result</strong><p>See risk bands and a note for each measure.</p></div></article>
                <article><span class="summary-icon">03</span><div><strong>Explore local patterns</strong><p>Regional map planned for verified sample data.</p></div></article>
            </section>
            <section class="map-preview" id="regional-map">
                <div>
                    <p class="eyebrow">Regional water map</p>
                    <h2>See patterns across India</h2>
                    <p>Future map colors each area by the latest reported sample results. It will show sample count, date, and data source when you select a region.</p>
                </div>
                <div class="map-legend" aria-label="Map color legend">
                    <span><i class="legend-dot safe-dot"></i>Lower risk</span>
                    <span><i class="legend-dot moderate-dot"></i>Moderate</span>
                    <span><i class="legend-dot critical-dot"></i>Higher risk</span>
                </div>
                <p class="map-note">Map data is not connected yet. No regional safety claims are shown here.</p>
            </section>
            <h2 class="section-heading" id="recent-activity">New sample analysis</h2>
            <p class="form-description">Enter laboratory or field-test values, or load a demo scenario and adjust it.</p>
            <% if (request.getAttribute("analysisError") != null) { %>
                <p class="form-message error" role="alert"><%= request.getAttribute("analysisError") %></p>
            <% } %>
            <div class="scenario-panel" aria-labelledby="scenario-title">
                <h2 id="scenario-title">Try a sample scenario</h2>
                <div class="scenario-buttons" id="scenario-buttons" data-scenarios="<%= request.getContextPath() %>/data/sample-scenarios.json">
                </div>
                <p class="helper-text" id="scenario-message" aria-live="polite"></p>
            </div>
            <form id="analysis-form" action="<%= request.getContextPath() %>/analyze" method="post">
                <fieldset>
                    <legend>Sample details</legend>
                    <div class="analysis-grid">
                        <div class="form-group">
                            <label for="state">State</label>
                            <input id="state" name="state" maxlength="80" required>
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
                                <option>Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="collectionDate">Sample collection date</label>
                            <input id="collectionDate" name="collectionDate" type="date" required>
                        </div>
                    </div>
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
