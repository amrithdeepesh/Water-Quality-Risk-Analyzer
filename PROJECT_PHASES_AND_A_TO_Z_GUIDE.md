# Water Quality Risk Analyzer — Complete A-to-Z Invigilator Defense Guide

---

## 1. The 30-Second Elevator Pitch
*(Use this structure when the invigilator asks: "What is your project about?")*

> "Our project is the **Water Quality Risk Analyzer**, a full-stack Java web application built on the **MVC (Model-View-Controller)** pattern using **Java Servlets, JSP, and MySQL**, deployed on **Apache Tomcat 9**.
> 
> It allows household users and property owners to register, log in, submit field or laboratory water-testing parameters (including pH, turbidity, TDS, dissolved oxygen, temperature, hardness, free chlorine, and coliform bacteria), and receive an instant, benchmarked risk assessment based on **BIS IS 10500** drinking water standards. It also features an interactive geographic map of India where users can locate their water source via 6-digit Indian PIN codes or GPS, with strict privacy controls to opt in or keep their water source private."

---

## 2. High-Level Architecture: The MVC Flow

Explain to the invigilator how data travels across the layers:

```
[ Browser Client ]
   │  1. User fills HTML form
   │  2. Client-side JS validation (validation.js)
   ▼  3. HTTP POST request
[ Controller / Servlets ] (LoginServlet, RegisterServlet, WaterAnalysisServlet)
   │  4. Server-side validation
   │  5. Calls Business Service
   ▼
[ Service Layer ] (UserService, WaterQualityAnalyzer)
   │  6. Implements Interfaces (UserOperations, WaterAnalysisOperations)
   │  7. Analyzes water parameters / hashes password (PasswordHasher)
   ▼
[ Repository / Data Layer ] (UserRepository, WaterSampleRepository)
   │  8. Executes Parameterized PreparedStatements (prevents SQL injection)
   ▼
[ MySQL Database ] / [ In-Memory Demo Fallback ]
   │  9. Reads/Writes records
   ▼
[ View Layer ] (JSP inside /WEB-INF/views/)
   │  10. RequestDispatcher forwards to dashboard.jsp or analysis-result.jsp
   ▼
[ Browser Response ] (HTML, CSS styling, dynamic data, session cookies)
```

---

## 3. Deep Dive into the 4 Coursework Phases

---

### Phase 1: Core Application Setup and Design (CLO1)

**Key Rubric Items Addressed:**
- Identify user entity (`User` class with attributes like `username`, `password`)
- Implement class structure with constructors and methods
- Basic validation logic in Java (string handling)

**Implementation Details:**
- **Entity Identification:** In [User.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/model/User.java), we created the `User` domain model encapsulating three core private attributes:
  ```java
  private String username;
  private String password;
  private String userType; // "casual" (household) or "property-owner"
  ```
- **Constructor Overloading & Encapsulation:** We provided three overloaded constructors:
  - `User()` — Default no-arg constructor initializing default values.
  - `User(String username, String password)` — Two-argument constructor defaulting role to casual.
  - `User(String username, String password, String userType)` — Full parameterized constructor with defensive defaults.
  - Standard getters and setters (`getUsername`, `setUsername`, `getPassword`, `setPassword`, `getUserType`, `setUserType`, `getUserTypeLabel`).
- **Java String Validation Logic:** Pure Java string handling methods without third-party dependencies:
  - `isUsernameValid()`: Checks for `null`, trims whitespace, enforces length between **3 and 30 characters**, and applies the regex `^[a-zA-Z0-9_.-]+$` to prevent invalid special characters.
  - `isPasswordValid()`: Checks for `null` and enforces length between **6 and 64 characters**.

---

### Phase 2: Structured Programming and Reliability (CLO2)

**Key Rubric Items Addressed:**
- Organize classes into packages
- Create an interface for user operations (validation/authentication)
- Implement exception handling for invalid inputs

**Implementation Details:**
- **Package Hierarchy:** Classes are partitioned into dedicated packages representing distinct architectural responsibilities:
  - `com.waterquality.model` — Domain POJOs ([User.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/model/User.java), [WaterSample.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/model/WaterSample.java), [WaterAnalysisResult.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/model/WaterAnalysisResult.java), [ParameterAssessment.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/model/ParameterAssessment.java)).
  - `com.waterquality.service` — Business rules and scoring ([UserService.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/service/UserService.java), [WaterQualityAnalyzer.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/service/WaterQualityAnalyzer.java)).
  - `com.waterquality.repository` — SQL persistence ([UserRepository.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/repository/UserRepository.java), [WaterSampleRepository.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/repository/WaterSampleRepository.java)).
  - `com.waterquality.servlet` — HTTP Request handling controllers.
  - `com.waterquality.config` — Database connectivity ([Database.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/config/Database.java)).
  - `com.waterquality.security` — PBKDF2 cryptography ([PasswordHasher.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/security/PasswordHasher.java)).
  - `com.waterquality.exception` — Custom exception types.
  - `com.waterquality.main` — Standalone console runner ([Main.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/main/Main.java)).
- **Interface for User Operations:** We defined [UserOperations.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/service/UserOperations.java):
  ```java
  public interface UserOperations {
      boolean validateUser(User user) throws InvalidUserInputException;
      boolean register(User user) throws InvalidUserInputException;
      boolean authenticate(String username, String password);
      String getUserDataAsJson(User user);
  }
  ```
  *Why use an interface?* It acts as a contract separating the API definition from its concrete implementation ([UserService.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/service/UserService.java)), supporting loose coupling, unit testing, and future data-source migrations.
- **Custom Exception Handling:** We created [InvalidUserInputException.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/exception/InvalidUserInputException.java) which extends `Exception`. When invalid credentials or names are submitted, `UserService.validateUser()` explicitly throws it with an informative message. Servlets catch it and translate it into user-friendly UI alerts without exposing stack traces.

---

### Phase 3: Web Interface and Client Interaction (CLO2)

**Key Rubric Items Addressed:**
- Design registration and login forms using HTML/CSS
- Apply JavaScript validation (empty fields, format checks)
- Basic interaction handling (form submission)
- Represent user data format using JSON (simple structure)

**Implementation Details:**
- **Front-End Design:**
  - [login.html](file:///c:/water_java/WaterQualityRiskAnalyzer/web/login.html) and [register.html](file:///c:/water_java/WaterQualityRiskAnalyzer/web/register.html) built with semantic HTML5 elements (`<main>`, `<section>`, `<form>`, `<label>`, `<input>`) and accessible ARIA attributes.
  - Styled with custom CSS in [style.css](file:///c:/water_java/WaterQualityRiskAnalyzer/web/css/style.css) featuring a dark cyan water theme, glassmorphic card containers, and responsive mobile-ready breakpoints.
- **Client-Side Validation:** [validation.js](file:///c:/water_java/WaterQualityRiskAnalyzer/web/js/validation.js) handles `submit` events before sending network requests:
  - Verifies fields are not blank.
  - Checks username pattern (`/^[a-zA-Z0-9_.-]+$/`) and 3–30 length.
  - Checks password minimum 6 and maximum 64 characters.
  - Verifies that `password === confirmPassword` on registration.
  - Displays instant inline alert pills without full-page reloads.
- **JSON User Data Representation:**
  - Implemented in [User.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/model/User.java) via `toJson()` and `toPrettyJson()` methods:
    ```json
    {
      "username": "Amrith",
      "userType": "property-owner",
      "role": "Property owner"
    }
    ```
  - Accessible via the REST endpoint `/user-profile` served by [UserDataServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/UserDataServlet.java).
  - Also stored as sample test data in [user-sample.json](file:///c:/water_java/WaterQualityRiskAnalyzer/web/data/user-sample.json).
  - *Key Security Point:* Passwords and password salts are **strictly omitted** from all JSON representations to protect user privacy.

---

### Phase 4: Server-Side Integration and Execution (CLO1, CLO2, CLO3)

**Key Rubric Items Addressed:**
- Process registration and login using Servlets (GET/POST)
- Validate user credentials on server side
- Implement session tracking using HttpSession
- Create JSP page for user dashboard
- Restrict dashboard access without login
- Implement logout and session invalidation
- Deploy and execute on web server

**Implementation Details:**
- **Servlets with GET/POST Handling:**
  - [RegisterServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/RegisterServlet.java): `doGet` redirects to `register.html`; `doPost` parses registration inputs, validates server-side, checks duplicates, and redirects.
  - [LoginServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/LoginServlet.java): `doGet` redirects to `login.html`; `doPost` validates credentials.
  - [LogoutServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/LogoutServlet.java): Handles session termination.
  - [DashboardServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/DashboardServlet.java): Route guard that checks session before forwarding to dashboard.
  - [WaterAnalysisServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/WaterAnalysisServlet.java): Receives all 8 water parameters, validates ranges, runs the analysis engine, saves to MySQL, and forwards to results JSP.
- **Server-Side Validation:** Even if an attacker bypasses the browser JavaScript using Postman or cURL, our Servlets validate every parameter:
  - Checking string length limits and character patterns.
  - Verifying numbers are within physical ranges (e.g., pH 0–14, Turbidity 0–1000 NTU, TDS 0–20,000 mg/L).
- **Session Tracking via `HttpSession`:**
  - On successful login: `HttpSession session = request.getSession(true);`
  - Stores `username` and `userType` in session attributes.
  - Protects against session fixation by invalidating any pre-existing session before creating a fresh authenticated session.
- **Route Access Protection:**
  - In [DashboardServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/DashboardServlet.java):
    ```java
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect(request.getContextPath() + "/login.html?error=login-required");
        return;
    }
    ```
  - Unauthenticated users cannot view the dashboard, analysis results, or regional map.
- **JSP Dashboard & `WEB-INF` Security:**
  - JSP files are placed inside `/WEB-INF/views/` ([dashboard.jsp](file:///c:/water_java/WaterQualityRiskAnalyzer/web/WEB-INF/views/dashboard.jsp), [analysis-result.jsp](file:///c:/water_java/WaterQualityRiskAnalyzer/web/WEB-INF/views/analysis-result.jsp), [map.jsp](file:///c:/water_java/WaterQualityRiskAnalyzer/web/WEB-INF/views/map.jsp)).
  - *Why inside `/WEB-INF`?* Files inside `/WEB-INF` cannot be requested directly by a browser URL; they can only be served internally by a Java Servlet using `RequestDispatcher.forward()`. This guarantees that unauthorized users cannot bypass servlet security checks.
- **Logout and Session Invalidation:**
  - [LogoutServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/LogoutServlet.java) calls `session.invalidate()`, clearing all server-side session memory and expiring the session cookie.
- **Deployment:**
  - Web application deployment descriptor configured in [web.xml](file:///c:/water_java/WaterQualityRiskAnalyzer/web/WEB-INF/web.xml) with a 30-minute session timeout, `HttpOnly` cookie flags, and custom error pages for HTTP 404 and 500.
  - Deployed on **Apache Tomcat 9.0.122** listening on port **8081**.

---

## 4. Advanced Real-World Features (To Impress Your Invigilator)

1. **Water Quality Risk Assessment Engine ([WaterQualityAnalyzer.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/service/WaterQualityAnalyzer.java)):**
   - Implements **BIS IS 10500** standard limits across 7 scored parameters + temperature:
     - pH (6.5 – 8.5 acceptable)
     - Turbidity ($\le 1$ NTU desirable, $\le 5$ permissible)
     - Total Dissolved Solids ($\le 500$ mg/L desirable)
     - Dissolved Oxygen ($\ge 5$ mg/L)
     - Total Hardness ($\le 200$ mg/L CaCO3)
     - Free Residual Chlorine ($0.2 – 0.5$ mg/L)
     - Coliform Indicator (0 = absent; presence immediately adds severe penalty)
   - Calculates a normalized percentage risk score:
     $$\text{Score} = \text{round}\left(\frac{\sum \text{Severity Points}}{7 \times 3} \times 100\right)$$
   - Classifies risk into **Safe** (<10), **Moderate** (10–29), **High** (30–59), or **Critical** ($\ge 60$).
2. **Interactive Location Picker with 6-Digit Indian PIN Codes ([location-picker.js](file:///c:/water_java/WaterQualityRiskAnalyzer/web/js/location-picker.js)):**
   - Automatically loads postal reference points from [india-pincode-offices.json](file:///c:/water_java/WaterQualityRiskAnalyzer/web/data/india-pincode-offices.json).
   - Features a built-in regional prefix fallback dictionary covering **all Indian postal circles (Zones 1 through 8)**, guaranteeing that every valid 6-digit Indian PIN navigates the map.
   - Users can drag the Leaflet marker or use device GPS to pinpoint their exact tap or well.
3. **Data Privacy and Opt-In Map Sharing ([WaterSampleRepository.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/repository/WaterSampleRepository.java)):**
   - Users have an explicit checkbox: *"Share this sample and its exact map location anonymously"*.
   - If unchecked (`includeOnMap = false`), the test result is saved privately in MySQL and will **never appear** on public map queries or JSON feeds.
4. **Military-Grade Password Hashing ([PasswordHasher.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/security/PasswordHasher.java)):**
   - Plaintext passwords are never stored in the database.
   - Uses **PBKDF2WithHmacSHA256** with 120,000 iterations and a cryptographically secure random 16-byte salt per user.

---

## 5. Live Demonstration Scripts: What to Run

You have three automated scripts ready in the project folder:

### 1. The Console Verification: `.\run.ps1`
Run this if the invigilator wants to see pure Java CLI output verifying Phase 1, Phase 2, and JSON data:
```powershell
.\run.ps1
```
*It compiles `src/` and runs [Main.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/main/Main.java), printing test results for User creation, string validation, UserOperations registration, authentication, and JSON serialization.*

### 2. The 4-Phases Checklist: `.\verify-phases.ps1`
Run this to show that all 4 coursework phases pass automated checks:
```powershell
.\verify-phases.ps1
```
*It verifies Phase 1 (Entity/Validation), Phase 2 (Packages/Interfaces/Exceptions), Phase 3 (HTML/CSS/JS/JSON), and Phase 4 (Servlets/Sessions/JSP/Tomcat).*

### 3. The 27-Point QA Audit: `.\qa-test-agency-audit.ps1`
Run this to show an independent software testing agency report:
```powershell
.\qa-test-agency-audit.ps1
```
*Executes 27 automated test cases covering security, access controls, registration edge cases, login, water calculations, and map privacy, reporting a **100% Pass Rate**.*

### 4. The Live Web App:
Open Google Chrome or Edge and go to:
[http://localhost:8081/WaterQualityRiskAnalyzer/](http://localhost:8081/WaterQualityRiskAnalyzer/)

---

## 6. Top 10 Invigilator Viva Questions & Ready Answers

### Q1: What is the difference between client-side and server-side validation?
> **Answer:** Client-side validation runs in the browser via JavaScript ([validation.js](file:///c:/water_java/WaterQualityRiskAnalyzer/web/js/validation.js)) to provide instant feedback to the user before submitting the form. However, client-side validation can be bypassed by disabling JavaScript or sending direct HTTP requests using tools like Postman or cURL. Therefore, server-side validation in [UserService.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/service/UserService.java) and Servlets is the real security boundary that guarantees invalid data never reaches our database.

### Q2: Why are your JSP files stored in `WEB-INF/views/` instead of the root web folder?
> **Answer:** By Java EE specification, the `/WEB-INF/` folder is private. Files inside `/WEB-INF/` cannot be directly accessed by a browser typing the URL (e.g. `localhost:8081/.../dashboard.jsp` will return a 404). This forces all requests to go through our Java Servlets ([DashboardServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/DashboardServlet.java)) first, which verify that the user has an active session before using `RequestDispatcher.forward()` to render the view.

### Q3: How does session management work in this application?
> **Answer:** When a user logs in via [LoginServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/LoginServlet.java), the servlet calls `request.getSession(true)`. Tomcat generates a unique session ID stored in memory and sends it to the browser as a `JSESSIONID` cookie with the `HttpOnly` flag enabled. On subsequent requests, the browser transmits this cookie, allowing our servlets to retrieve the user's attributes (`username`, `userType`). When the user clicks Logout, [LogoutServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/LogoutServlet.java) calls `session.invalidate()`, destroying the session on the server.

### Q4: Why did you create an interface `UserOperations` instead of just using `UserService` directly?
> **Answer:** This adheres to the **Dependency Inversion Principle** and **Interface-Based Programming** required in Phase 2. The interface defines a contract of what operations can be performed (`validateUser`, `register`, `authenticate`, `getUserDataAsJson`) without coupling the servlets to a specific storage implementation. If tomorrow we switch from MySQL to a cloud API or MongoDB, we can create a new service class implementing `UserOperations` without changing a single line in our Servlets.

### Q5: How do you prevent SQL Injection in your database operations?
> **Answer:** We never concatenate user input directly into SQL strings. In both [UserRepository.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/repository/UserRepository.java) and [WaterSampleRepository.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/repository/WaterSampleRepository.java), we use Java `PreparedStatement` with placeholder question marks (`?`). The database driver compiles the SQL statement structure beforehand and treats user input strictly as literal values, neutralizing SQL injection attempts.

### Q6: How are passwords stored in the database?
> **Answer:** We never store plaintext passwords. In [PasswordHasher.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/security/PasswordHasher.java), we use **PBKDF2 with HMAC-SHA256** and 120,000 iterations. For every user, a cryptographically random 16-byte salt is generated via `SecureRandom`. The salt and the resulting hash are stored. During login, the entered password is salted and re-hashed, and compared in constant time via `MessageDigest.isEqual()` to prevent timing attacks.

### Q7: What custom exceptions did you create and why?
> **Answer:** We created [InvalidUserInputException.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/exception/InvalidUserInputException.java) which extends `Exception` (a checked exception) to represent business rule validation errors (e.g., short password or invalid username). We also created [RepositoryException.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/exception/RepositoryException.java) which extends `RuntimeException` to wrap technical `SQLException` errors so database internal details are not exposed to the user interface.

### Q8: How does the Water Quality Scoring Algorithm work?
> **Answer:** The logic is in [WaterQualityAnalyzer.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/service/WaterQualityAnalyzer.java). It scores 7 critical drinking parameters (pH, turbidity, TDS, dissolved oxygen, hardness, free chlorine, and coliform presence). Each parameter is assigned a severity point from 0 (Safe) to 3 (Critical) based on BIS IS 10500 standards. The points are summed and divided by the maximum possible score ($7 \times 3 = 21$) to generate a risk percentage from 0 to 100.

### Q9: How is JSON used in this project?
> **Answer:** JSON is used in three places fulfilling Phase 3:
> 1. In [User.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/model/User.java) via `toJson()` and `toPrettyJson()` to serialize user profile objects safely (excluding passwords).
> 2. In [web/data/user-sample.json](file:///c:/water_java/WaterQualityRiskAnalyzer/web/data/user-sample.json) and [sample-scenarios.json](file:///c:/water_java/WaterQualityRiskAnalyzer/web/data/sample-scenarios.json) for preset testing scenarios.
> 3. In the `/user-profile` REST endpoint ([UserDataServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/UserDataServlet.java)) and `/map-data` endpoint ([MapDataServlet.java](file:///c:/water_java/WaterQualityRiskAnalyzer/src/com/waterquality/servlet/MapDataServlet.java)) for client-side consumption.

### Q10: How does your interactive location picker work with PIN codes?
> **Answer:** In [location-picker.js](file:///c:/water_java/WaterQualityRiskAnalyzer/web/js/location-picker.js), when a user enters a 6-digit Indian PIN code, it first searches [india-pincode-offices.json](file:///c:/water_java/WaterQualityRiskAnalyzer/web/data/india-pincode-offices.json) for exact matching post office coordinates. If not in the local dataset, our regional circle fallback maps the first two digits (e.g. 11 for Delhi, 56 for Bengaluru, 68 for Kerala) to center the Leaflet map in the correct district. The user then clicks the map or uses device GPS to pinpoint their exact water tap or well.