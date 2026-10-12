# Water Quality Risk Analyzer: phase review and A-to-Z guide

## What this project is

This is a Java Servlet/JSP learning project. A user enters field or laboratory readings; the application applies a simple project scoring rule, stores the analysis in MySQL, and can show samples on a regional map. It is a coursework demonstration, not a certified water-testing service.

## Phase completion review against the coursework checklist

| Phase | Review | Evidence and remaining item |
|---|---|---|
| 1. Core application setup and design | Complete for the coursework scope | User model, constructors, getters, user-type distinction, and Java/browser validation are present. |
| 2. Structured programming and reliability | Complete for the coursework scope | Packages separate models, services, repositories, configuration, security, exceptions, and servlets. Interfaces and exception handling are used. |
| 3. Web interface and client interaction | Mostly complete; one checklist item is partial | HTML/CSS pages, JavaScript validation, form submission, and JSON sample/map data are present. The rubric asks for a JSON representation of user data; there is no account JSON serializer or user-data endpoint yet. Add a safe representation that excludes passwords to fully satisfy that exact item. |
| 4. Server-side integration and execution | Complete as a local demo | Registration/login use POST servlets; server-side validation, MySQL, sessions, protected dashboard/map routes, logout, and Tomcat launch are implemented. Production deployment controls are still missing. |

These labels describe the requested coursework criteria. They do not mean that the site is ready to make real drinking-water safety decisions.

## Start the project

1. Start the local MySQL service if you want persistent accounts and analyses.
2. Open PowerShell and go to C:/water_java/WaterQualityRiskAnalyzer.
3. If MySQL has not been initialized, run setup-mysql.ps1 and enter a MySQL administrator account when asked. The script creates the schema, a restricted application account, and synthetic practice samples. Do not paste or commit database passwords.
4. Run run-web.ps1. It compiles the Java sources for the Servlet API, copies the website into the bundled Tomcat app folder, and starts Tomcat on port 8081.
5. Open http://localhost:8081/WaterQualityRiskAnalyzer/ in a browser. Do not open the HTML file directly from the file system because servlets and sessions require Tomcat.
6. When Tomcat is already running, stop it before starting another copy. To stop it from PowerShell, set CATALINA_HOME to the project’s .tools/apache-tomcat-9.0.122 folder and JAVA_HOME to the JDK folder, then run its bin/shutdown.bat.

The .tools folder contains local Tomcat files and an encrypted database password. It is excluded from Git. Keep it that way.
## The project folders

- src/com/waterquality/model contains data objects such as User, WaterSample, and WaterAnalysisResult.
- src/com/waterquality/service contains application rules: account validation and the water-score calculation.
- src/com/waterquality/repository contains MySQL reads and writes.
- src/com/waterquality/servlet connects HTTP requests to services and pages.
- src/com/waterquality/config holds the database connection setup.
- src/com/waterquality/security contains password hashing.
- web contains public HTML, CSS, browser JavaScript, JSON sample data, and WEB-INF JSP views.
- web/WEB-INF/views contains dashboard, result, and map pages. WEB-INF prevents a browser from opening those JSP files directly.
- database/schema.sql creates the MySQL tables and synthetic map samples.
- run-web.ps1 builds and launches the web application; setup-mysql.ps1 prepares MySQL.

## How one request travels through the app

A user fills in an HTML form. JavaScript checks basic fields in the browser, but browser checks can be bypassed, so the servlet validates them again. A servlet calls a service for the application rule. A repository uses prepared SQL statements to store or retrieve data. The servlet either redirects to another URL or forwards the request to a JSP. The browser receives the HTML response.

For a water analysis, the path is:
Dashboard JSP form → POST /analyze → WaterAnalysisServlet → WaterQualityAnalyzer → WaterSampleRepository → MySQL → analysis-result.jsp.

For login, the path is:
login.html → POST /login → LoginServlet → UserService → UserRepository → MySQL → HttpSession → protected /dashboard.

For the regional map, the page loads Leaflet and requests /map-data. MapDataServlet checks the login session. The repository returns synthetic practice samples and samples whose contributors opted in to sharing. The browser draws a marker from each latitude/longitude pair.

## Phase 1: core setup and design

A class is a blueprint for related data and behavior. User stores a username, password temporarily during registration, and user type. Its constructors create a user with a default casual-user role or an explicit role. Getters let other classes read those values. The database does not store the plain password: UserRepository makes a salted PBKDF2 hash before saving.
Validation rejects an empty or too-short username and password. Browser validation gives quick feedback; server validation is the actual boundary because requests can be sent without the page. WaterAnalysisServlet also checks numeric ranges, dates, state/source text, and the new latitude/longitude values.

What to learn: fields describe an object; a constructor initializes it; a method performs behavior; a getter exposes a field; validation rejects data that cannot be safely used.

## Phase 2: packages, interfaces, and errors

Packages group related Java files and keep the application understandable. The model package describes data. The service package contains rules. The repository package handles storage. The servlet package handles web requests. Config and security hold cross-cutting support.

An interface is a contract. UserOperations describes the account operations that UserService supplies. WaterAnalysisOperations describes the analysis operation that WaterQualityAnalyzer supplies. This lets code depend on a role or capability instead of a particular class.

InvalidUserInputException reports user-entry errors. RepositoryException reports storage errors. Servlets catch expected errors and show a useful message instead of exposing SQL details. Prepared statements bind user values separately from SQL text, which helps prevent SQL injection.

What to learn: keep business rules out of JSP pages; keep SQL out of page scripts; catch errors at the boundary where a useful response can be given.

## Phase 3: pages and browser interaction

The static pages are index.html, login.html, and register.html. The servlet forwards protected views to dashboard.jsp, analysis-result.jsp, and map.jsp. style.css contains the shared dark water theme. validation.js checks login and registration fields. analysis.js loads JSON scenarios and uses browser geolocation only after the user presses the location button. map.js initializes the map and draws filtered sample markers.

JSON is a text format for structured data. The project uses JSON for sample scenarios and fallback map samples. The coursework checklist also names a user-data JSON structure; this code does not yet serialize a User account to JSON. If you add it, never include the password or password hash in the JSON.

Map navigation: drag inside the map to pan; use the plus/minus controls, mouse wheel, or touch gestures to zoom. A map marker popup shows the source, date, project risk band, and exact saved coordinates.

Location behavior: the user enters a six-digit India PIN, can search its bundled postal-office coordinates, and then clicks the actual sampling point on the Leaflet map or chooses Use my current location. The PIN dataset has limited coordinate coverage and a postal-office point is only an area reference, not the location of a tap or well. Device GPS can also be several metres away, so the user must confirm or adjust the point. Source details and coverage are documented in web/data/PIN-DATA-SOURCE.md. The application stores coordinates for the analysis. A sample appears on the shared map only when its owner checks the explicit sharing option; shared exact coordinates are visible to map visitors.

## Phase 4: servlets, sessions, database, and Tomcat

A servlet is a Java class that receives HTTP requests. RegisterServlet handles account creation; LoginServlet verifies credentials and starts a session; DashboardServlet and MapServlet protect their pages; MapDataServlet returns map JSON; WaterAnalysisServlet validates and analyzes submitted readings; LogoutServlet invalidates the session.
HttpSession is server-side state associated with a browser cookie. It remembers the signed-in username and role between page requests. Protected servlets check for a session before forwarding the private page. Logout invalidates it. Tomcat loads the application, compiles JSP views, runs servlets, and serves the pages at the localhost URL.

MySQL stores users and analyses. users contains account identity, user type, password salt, and password hash. water_samples contains source, date, readings, risk result, coordinates, and a map-sharing flag. The database account created by setup-mysql.ps1 has limited table permissions. The local app-password file is encrypted for the Windows account that set it up.

## How to understand the score

WaterQualityAnalyzer applies fixed thresholds to pH, turbidity, total dissolved solids, dissolved oxygen, hardness, free residual chlorine, and a coliform indicator. Temperature is recorded for context. It assigns project severity values, adds them, and converts the total into a project score and label.

The thresholds and labels are demonstration logic. A low project score does not prove water is safe. A high score is not a diagnosis. The current form covers only a small set of indicators and does not replace accredited laboratory testing or official guidance.

## Verification performed for this revision

- Java compilation and Tomcat startup completed successfully in MySQL mode.
- Live HTTP integration checks passed for home/login/register pages, scenario JSON, anonymous dashboard protection, owner and casual roles, registration, duplicate rejection, wrong-password rejection, correct login, map page and sample feed, water analysis, exact coordinate persistence, opt-in map sharing, hidden private samples, invalid-coordinate rejection, logout, and session invalidation.
- Shared test coordinates appeared unchanged in the map JSON. A private test sample did not appear in the public map feed.
- Temporary test accounts and their sample rows were deleted after the checks.
- All browser JavaScript files passed Node syntax checking.
- The map page’s delivered script enables dragging and wheel zoom; the map stylesheet gives it an explicit height.

The test used HTTP requests rather than a person operating every control in a graphical browser. The geolocation permission prompt depends on the user’s browser and device and must be tried there. The map’s basemap also needs an internet connection.

## What is still missing for real-world use

Do not launch this as a drinking-water safety service yet. Prioritize these items:

1. Scientific and regulatory review: have qualified water-quality professionals verify every limit, unit, scoring rule, interpretation, and recommendation against current authoritative standards. Add citations and clear uncertainty. Validate against real laboratory data.
2. Broader and quality-controlled testing: define sample collection, preservation, calibration, lab methods, detection limits, chain of custody, and how to handle missing or conflicting results. Add the contaminants and microbial indicators appropriate to the intended use.3. Privacy and consent: precise coordinates can identify a home or private water source. Add location fuzzing for public maps, clear retention rules, consent records, account/data deletion, and a way to withdraw shared records.
4. Production security: HTTPS, CSRF protection, secure/HttpOnly/SameSite cookies, session timeout, login throttling, password reset, stronger password policy, dependency updates, security review, and secrets management are needed. Avoid publishing the development database or credentials.
5. Operations: production database backups and restore drills, schema migrations, connection pooling, monitoring, alerting, error handling, logs without secrets, deployment automation, and a tested recovery plan.
6. Data quality and moderation: provenance, verified/unverified status, moderation for community submissions, duplicate detection, audit history, and clear separation of synthetic data from verified measurements.
7. Product features: per-user history, multiple properties and sample points, charts over time, report export, reminders, admin tools, accessible mobile UI, translations, and support/contact channels.
8. Map service: check the chosen OpenStreetMap tile service’s usage policy before real traffic; consider a licensed or hosted provider, clustering, boundaries, data freshness, and precise-location privacy.

## A-to-Z study path

1. Draw the page-to-servlet flow before editing code.
2. Read User.java and WaterSample.java to understand models and constructors.
3. Read UserOperations.java and WaterAnalysisOperations.java to understand interfaces.
4. Read UserService.java and WaterQualityAnalyzer.java to understand business rules.
5. Read UserRepository.java and WaterSampleRepository.java to understand prepared SQL and data storage.
6. Read RegisterServlet.java and LoginServlet.java to understand POST form handling.
7. Read DashboardServlet.java, MapServlet.java, and MapDataServlet.java to understand sessions and protected pages.
8. Read validation.js, analysis.js, and map.js to understand browser behavior.
9. Read dashboard.jsp and map.jsp to understand how forms and controls connect to endpoints.
10. Read database/schema.sql, then run setup-mysql.ps1 only for a local development database.
11. Change one thing at a time, compile with run-web.ps1, then check the browser and server logs.
12. Before any real use, get scientific, privacy, security, and operational reviews.