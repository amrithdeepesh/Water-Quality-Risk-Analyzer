# MySQL setup

The project supports MySQL 8. Without MySQL credentials it falls back to temporary demo accounts and local sample data.

## One-time local setup

1. Start the local MySQL service.
2. Open PowerShell in C:/water_java/WaterQualityRiskAnalyzer.
3. Run .\setup-mysql.ps1.
4. Enter a MySQL administrator username and password at the prompts. The password prompt is hidden.
5. The script creates the database, tables, 41 synthetic practice map samples, and a restricted application account. It stores the app password encrypted under the ignored .tools folder for the same Windows account.

Then run .\run-web.ps1. If an old Tomcat process is already using port 8081, stop it first.

## Stored information

- Usernames, user type, random password salt, and PBKDF2 password hash.
- Submitted water readings, collection date, exact latitude/longitude, and the project score.
- Map sharing choice. A sample is private on the map unless its owner explicitly opts in.

A user-shared sample's exact coordinates are shown to map visitors. Do not share a home or private water-source location unless you intend to make that point public. Synthetic seed records are practice data, not official measurements.

The app account is restricted to the project database. Do not commit .tools, database passwords, or local production data.