# Water Quality Risk Analyzer

A Java Servlet/JSP coursework project for user registration, water-sample analysis, MySQL storage, and a regional sample map. The score is educational demonstration logic, not a drinking-water safety result.

## Coursework phase review

| Phase | Status |
|---|---|
| 1. Core application setup and design | Complete for coursework scope |
| 2. Structured programming and reliability | Complete for coursework scope |
| 3. Web interface and client interaction | Mostly complete; user-account JSON representation remains to satisfy one rubric item |
| 4. Server-side integration and execution | Complete as a local Tomcat/MySQL demo |

See PROJECT_PHASES_AND_A_TO_Z_GUIDE.md for the detailed rubric audit, request flows, test report, learning guide, and real-world readiness gaps.

## Run locally

1. Start MySQL if you want persistent data.
2. Run setup-mysql.ps1 once if the database has not been initialized.
3. Run run-web.ps1.
4. Open http://localhost:8081/WaterQualityRiskAnalyzer/.

Use the served URL so that Java servlets and sessions work. See database/README.md for database setup instructions. Local Tomcat files and the encrypted app credential are in the ignored .tools folder and should not be pushed to GitHub.

## Regional map and sample locations

The map includes synthetic city-center practice samples. Submitted analyses require a latitude and longitude for the test point. The contributor must opt in before that sample and its exact coordinates appear on the shared map. The browser can fill coordinates from device location when the user presses the location button; GPS may still be metres from the actual tap or well, so review the point.

The map uses Leaflet and OpenStreetMap tiles. Internet access is required for the basemap. Map colors show only this project’s simple risk categories.

## Real-world readiness

This is not ready for public drinking-water decisions or commercial deployment. The thresholds and recommendations need qualified scientific review; production needs privacy protection for exact coordinates, HTTPS, CSRF and session controls, account recovery, tested backups, monitoring, data-quality processes, security review, and a licensed map-tile plan. The guide details these requirements.
