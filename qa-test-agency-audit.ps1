# ==============================================================================
# WATER QUALITY RISK ANALYZER - QA TEST AGENCY AUTOMATED AUDIT SUITE
# ==============================================================================
$ErrorActionPreference = 'Stop'

$baseUrl = 'http://localhost:8081/WaterQualityRiskAnalyzer'
$results = [System.Collections.Generic.List[PSCustomObject]]::new()

function Record-Test {
    param(
        [string]$Suite,
        [string]$TestName,
        [bool]$Passed,
        [string]$Details = ""
    )
    $obj = [PSCustomObject]@{
        Suite    = $Suite
        TestName = $TestName
        Status   = if ($Passed) { "PASS" } else { "FAIL" }
        Details  = $Details
    }
    $results.Add($obj)
    $color = if ($Passed) { "Green" } else { "Red" }
    $tag = if ($Passed) { "[PASS]" } else { "[FAIL]" }
    Write-Host "$tag $Suite :: $TestName" -ForegroundColor $color
    if ($Details) {
        Write-Host "       $Details" -ForegroundColor Gray
    }
}

Write-Host "`n==================================================================" -ForegroundColor Cyan
Write-Host "   SOFTWARE TESTING AGENCY - INDEPENDENT QA AUDIT EXECUTION" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

# ------------------------------------------------------------------------------
# PRE-REQUISITE: ENSURE TOMCAT AND DATABASE ARE RUNNING ON PORT 8081
# ------------------------------------------------------------------------------
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$tomcatHome = Join-Path $projectRoot '.tools\apache-tomcat-9.0.122'
$startup = Join-Path $tomcatHome 'bin\startup.bat'

$portUse = Get-NetTCPConnection -LocalPort 8081 -State Listen -ErrorAction SilentlyContinue
if (-not $portUse) {
    Write-Host "Tomcat is not running on 8081. Launching server..." -ForegroundColor Yellow
    $passwordFile = Join-Path $projectRoot '.tools\water-db-password.dpapi'
    if (Test-Path -LiteralPath $passwordFile) {
        $encryptedPassword = Get-Content -LiteralPath $passwordFile -Raw
        $securePassword = ConvertTo-SecureString $encryptedPassword.Trim()
        $passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
        $env:WQ_DB_USER = 'water_quality_app'
        $env:WQ_DB_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPointer)
    }

    $compiler = Get-Command javac -ErrorAction Stop
    $env:JAVA_HOME = Split-Path -Parent (Split-Path -Parent $compiler.Source)

    Start-Process -FilePath 'C:\Windows\System32\cmd.exe' -ArgumentList @('/c', ('"' + $startup + '"')) -WorkingDirectory $tomcatHome -WindowStyle Hidden

    $ready = $false
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        try {
            $null = Invoke-WebRequest -Uri "$baseUrl/index.html" -UseBasicParsing -TimeoutSec 2
            $ready = $true
            break
        } catch {
            Start-Sleep -Seconds 1
        }
    }
    if (-not $ready) {
        throw "Failed to start Tomcat on port 8081."
    }
    Write-Host "Tomcat successfully started and listening on port 8081!" -ForegroundColor Green
} else {
    Write-Host "Tomcat is already active on port 8081." -ForegroundColor Green
}


# ------------------------------------------------------------------------------
# SUITE 1: STATIC & ASSET INTEGRITY
# ------------------------------------------------------------------------------
try {
    $res = Invoke-WebRequest -Uri "$baseUrl/index.html" -UseBasicParsing
    Record-Test "Asset Integrity" "Landing Page (index.html)" ($res.StatusCode -eq 200 -and $res.Content.Contains("Water Quality Risk Analyzer")) "HTTP 200 OK"
} catch {
    Record-Test "Asset Integrity" "Landing Page (index.html)" $false $_.Exception.Message
}

try {
    $res = Invoke-WebRequest -Uri "$baseUrl/css/style.css" -UseBasicParsing
    Record-Test "Asset Integrity" "CSS Stylesheet (style.css)" ($res.StatusCode -eq 200 -and $res.Content.Contains("--deep-water")) "HTTP 200 OK, Theme loaded"
} catch {
    Record-Test "Asset Integrity" "CSS Stylesheet (style.css)" $false $_.Exception.Message
}

try {
    $res = Invoke-WebRequest -Uri "$baseUrl/js/validation.js" -UseBasicParsing
    Record-Test "Asset Integrity" "Validation JS (validation.js)" ($res.StatusCode -eq 200 -and $res.Content.Contains("validateRegistration")) "HTTP 200 OK"
} catch {
    Record-Test "Asset Integrity" "Validation JS (validation.js)" $false $_.Exception.Message
}

try {
    $res = Invoke-WebRequest -Uri "$baseUrl/js/location-picker.js" -UseBasicParsing
    Record-Test "Asset Integrity" "Location Picker JS" ($res.StatusCode -eq 200 -and $res.Content.Contains("PIN_REGIONS")) "HTTP 200 OK"
} catch {
    Record-Test "Asset Integrity" "Location Picker JS" $false $_.Exception.Message
}

try {
    $res = Invoke-WebRequest -Uri "$baseUrl/data/sample-scenarios.json" -UseBasicParsing
    Record-Test "Asset Integrity" "Preset Scenarios JSON" ($res.StatusCode -eq 200 -and $res.Content.Contains("safe-bengaluru")) "HTTP 200 OK, Preset data verified"
} catch {
    Record-Test "Asset Integrity" "Preset Scenarios JSON" $false $_.Exception.Message
}

try {
    $res = Invoke-WebRequest -Uri "$baseUrl/data/india-pincode-offices.json" -UseBasicParsing
    Record-Test "Asset Integrity" "PIN Code Dataset JSON" ($res.StatusCode -eq 200 -and $res.Content.Contains("560001")) "HTTP 200 OK, Indian PIN data present"
} catch {
    Record-Test "Asset Integrity" "PIN Code Dataset JSON" $false $_.Exception.Message
}

# ------------------------------------------------------------------------------
# SUITE 2: ACCESS CONTROL & SECURITY ENFORCEMENT
# ------------------------------------------------------------------------------
function Check-Redirect {
    param([string]$Url, [string]$ExpectedSubstring)
    $req = [System.Net.HttpWebRequest]::Create($Url)
    $req.AllowAutoRedirect = $false
    try {
        $resp = $req.GetResponse()
        $loc = $resp.Headers["Location"]
        $resp.Close()
        return ($loc -ne $null -and $loc.Contains($ExpectedSubstring))
    } catch [System.Net.WebException] {
        $resp = $_.Exception.Response
        if ($resp) {
            $loc = $resp.Headers["Location"]
            $resp.Close()
            return ($loc -ne $null -and $loc.Contains($ExpectedSubstring))
        }
        return $false
    }
}

$dashBlock = Check-Redirect "$baseUrl/dashboard" "error=login-required"
Record-Test "Security" "Anonymous /dashboard blocked" $dashBlock "Redirects to login with error=login-required"

$mapBlock = Check-Redirect "$baseUrl/map" "error=login-required"
Record-Test "Security" "Anonymous /map blocked" $mapBlock "Redirects to login with error=login-required"

try {
    $req = [System.Net.HttpWebRequest]::Create("$baseUrl/map-data")
    $resp = $req.GetResponse()
    $resp.Close()
    Record-Test "Security" "Anonymous /map-data returns 401" $false "Returned HTTP 200 instead of 401"
} catch [System.Net.WebException] {
    $resp = $_.Exception.Response
    $is401 = ($resp -and [int]$resp.StatusCode -eq 401)
    if ($resp) { $resp.Close() }
    Record-Test "Security" "Anonymous /map-data returns 401" $is401 "Correctly rejected with HTTP 401 Unauthorized"
}

try {
    $req = [System.Net.HttpWebRequest]::Create("$baseUrl/user-profile")
    $resp = $req.GetResponse()
    $resp.Close()
    Record-Test "Security" "Anonymous /user-profile returns 401" $false "Returned HTTP 200 instead of 401"
} catch [System.Net.WebException] {
    $resp = $_.Exception.Response
    $is401 = ($resp -and [int]$resp.StatusCode -eq 401)
    if ($resp) { $resp.Close() }
    Record-Test "Security" "Anonymous /user-profile returns 401" $is401 "Correctly rejected with HTTP 401 Unauthorized"
}

# ------------------------------------------------------------------------------
# SUITE 3: USER REGISTRATION & AUTHENTICATION
# ------------------------------------------------------------------------------
# 3.1 Invalid registration - password mismatch
$mismatchUser = "test_user_" + (Get-Random -Maximum 999999)
$bodyMismatch = "username=$mismatchUser&password=password123&confirmPassword=password456&userType=casual"
$mismatchRedirect = $false
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/register")
$req.Method = "POST"
$req.ContentType = "application/x-www-form-urlencoded"
$req.AllowAutoRedirect = $false
$bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyMismatch)
$req.ContentLength = $bytes.Length
$s = $req.GetRequestStream()
$s.Write($bytes, 0, $bytes.Length)
$s.Close()
$resp = $req.GetResponse()
$loc = $resp.Headers["Location"]
$resp.Close()
Record-Test "User Management" "Password mismatch rejected" ($loc -and $loc.Contains("error=password-mismatch")) "Redirects to register.html?error=password-mismatch"

# 3.2 Invalid registration - short password
$bodyShort = "username=$mismatchUser&password=123&confirmPassword=123&userType=casual"
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/register")
$req.Method = "POST"
$req.ContentType = "application/x-www-form-urlencoded"
$req.AllowAutoRedirect = $false
$bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyShort)
$req.ContentLength = $bytes.Length
$s = $req.GetRequestStream()
$s.Write($bytes, 0, $bytes.Length)
$s.Close()
$resp = $req.GetResponse()
$loc = $resp.Headers["Location"]
$resp.Close()
Record-Test "User Management" "Short password (<6 chars) rejected" ($loc -and $loc.Contains("error=invalid")) "Redirects to register.html?error=invalid"

# 3.3 Valid Registration - Casual User
$casualUser = "qa_casual_" + (Get-Random -Maximum 999999)
$casualPass = "Secret987!"
$bodyCasual = "username=$casualUser&password=$casualPass&confirmPassword=$casualPass&userType=casual"
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/register")
$req.Method = "POST"
$req.ContentType = "application/x-www-form-urlencoded"
$req.AllowAutoRedirect = $false
$bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyCasual)
$req.ContentLength = $bytes.Length
$s = $req.GetRequestStream()
$s.Write($bytes, 0, $bytes.Length)
$s.Close()
$resp = $req.GetResponse()
$loc = $resp.Headers["Location"]
$resp.Close()
Record-Test "User Management" "Valid Casual User Registration" ($loc -and $loc.Contains("registered=1")) "Registered successfully and redirected to login"

# 3.4 Duplicate Registration Prevention
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/register")
$req.Method = "POST"
$req.ContentType = "application/x-www-form-urlencoded"
$req.AllowAutoRedirect = $false
$bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyCasual)
$req.ContentLength = $bytes.Length
$s = $req.GetRequestStream()
$s.Write($bytes, 0, $bytes.Length)
$s.Close()
$resp = $req.GetResponse()
$loc = $resp.Headers["Location"]
$resp.Close()
Record-Test "User Management" "Duplicate Registration Prevented" ($loc -and $loc.Contains("error=duplicate")) "Correctly caught duplicate username"

# 3.5 Valid Registration - Property Owner
$ownerUser = "qa_owner_" + (Get-Random -Maximum 999999)
$ownerPass = "SecureOwner456#"
$bodyOwner = "username=$ownerUser&password=$ownerPass&confirmPassword=$ownerPass&userType=property-owner"
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/register")
$req.Method = "POST"
$req.ContentType = "application/x-www-form-urlencoded"
$req.AllowAutoRedirect = $false
$bytes = [System.Text.Encoding]::UTF8.GetBytes($bodyOwner)
$req.ContentLength = $bytes.Length
$s = $req.GetRequestStream()
$s.Write($bytes, 0, $bytes.Length)
$s.Close()
$resp = $req.GetResponse()
$loc = $resp.Headers["Location"]
$resp.Close()
Record-Test "User Management" "Valid Property Owner Registration" ($loc -and $loc.Contains("registered=1")) "Registered successfully and redirected to login"

# 3.6 Invalid Credentials Login
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/login")
$req.Method = "POST"
$req.ContentType = "application/x-www-form-urlencoded"
$req.AllowAutoRedirect = $false
$badLogin = "username=$ownerUser&password=WrongPassword"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($badLogin)
$req.ContentLength = $bytes.Length
$s = $req.GetRequestStream()
$s.Write($bytes, 0, $bytes.Length)
$s.Close()
$resp = $req.GetResponse()
$loc = $resp.Headers["Location"]
$resp.Close()
Record-Test "Authentication" "Invalid password rejected" ($loc -and $loc.Contains("error=invalid-credentials")) "Redirects with error=invalid-credentials"

# 3.7 Valid Login & Session Creation (Property Owner)
$ownerJar = New-Object System.Net.CookieContainer
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/login")
$req.Method = "POST"
$req.ContentType = "application/x-www-form-urlencoded"
$req.AllowAutoRedirect = $false
$req.CookieContainer = $ownerJar
$goodLogin = "username=$ownerUser&password=$ownerPass"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($goodLogin)
$req.ContentLength = $bytes.Length
$s = $req.GetRequestStream()
$s.Write($bytes, 0, $bytes.Length)
$s.Close()
$resp = $req.GetResponse()
$loc = $resp.Headers["Location"]
$resp.Close()
Record-Test "Authentication" "Valid Owner Login & Session Established" ($loc -and $loc.EndsWith("/dashboard")) "Authenticated and directed to /dashboard"

# 3.8 Dashboard Content Verification (Authenticated)
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/dashboard")
$req.CookieContainer = $ownerJar
$resp = $req.GetResponse()
$reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
$dashHtml = $reader.ReadToEnd()
$resp.Close()
$hasOwnerInfo = $dashHtml.Contains($ownerUser) -and $dashHtml.Contains("Property owner")
Record-Test "Dashboard" "Personalized Dashboard Rendering" $hasOwnerInfo "Displays username and 'Property owner' badge"

# 3.9 JSON User Profile Endpoint Verification
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/user-profile")
$req.CookieContainer = $ownerJar
$resp = $req.GetResponse()
$reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
$profileJson = $reader.ReadToEnd()
$resp.Close()
$profileValid = $profileJson.Contains($ownerUser) -and $profileJson.Contains("property-owner") -and (-not $profileJson.Contains("password"))
Record-Test "User Profile" "Safe JSON User Profile Endpoint" $profileValid "Returned user JSON with password safely omitted: $($profileJson.Trim())"

# ------------------------------------------------------------------------------
# SUITE 4: WATER QUALITY ANALYSIS LOGIC & ENGINE ACCURACY
# ------------------------------------------------------------------------------
# Test 4.1: Safe Tap Water Scenario (Opt-in to Map Sharing)
$sharedCity = "BengaluruShared_" + (Get-Random -Maximum 999999)
$safeParams = "state=Karnataka&city=$sharedCity&pincode=560001&waterSource=Tap+Water&collectionDate=2026-10-26" +
              "&latitude=12.971600&longitude=77.594600&ph=7.2&turbidity=0.5&tds=250&dissolvedOxygen=7.0" +
              "&temperature=22&hardness=120&freeChlorine=0.3&coliformDetected=false&includeOnMap=true"

$req = [System.Net.HttpWebRequest]::Create("$baseUrl/analyze")
$req.Method = "POST"
$req.ContentType = "application/x-www-form-urlencoded"
$req.CookieContainer = $ownerJar
$bytes = [System.Text.Encoding]::UTF8.GetBytes($safeParams)
$req.ContentLength = $bytes.Length
$s = $req.GetRequestStream()
$s.Write($bytes, 0, $bytes.Length)
$s.Close()
$resp = $req.GetResponse()
$reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
$safeResultHtml = $reader.ReadToEnd()
$resp.Close()

$isSafe = $safeResultHtml.Contains("Safe") -and $safeResultHtml.Contains($sharedCity) -and $safeResultHtml.Contains("560001")
Record-Test "Analysis Engine" "Scenario A: Safe Tap Water" $isSafe "Assessed correctly as 'Safe' with BIS IS 10500 standards"

# Test 4.2: Critical River Sample Scenario (Coliform Positive, High TDS & Turbidity, Private Opt-Out)
$privateCity = "PrivTown_" + (Get-Random -Maximum 999999)
$criticalParams = "state=Uttar+Pradesh&city=$privateCity&pincode=221001&waterSource=River&collectionDate=2026-10-26" +
                 "&latitude=25.317600&longitude=82.973900&ph=10.2&turbidity=24&tds=4800&dissolvedOxygen=0.7" +
                 "&temperature=32&hardness=1600&freeChlorine=0.0&coliformDetected=true&includeOnMap=false"

$req = [System.Net.HttpWebRequest]::Create("$baseUrl/analyze")
$req.Method = "POST"
$req.ContentType = "application/x-www-form-urlencoded"
$req.CookieContainer = $ownerJar
$bytes = [System.Text.Encoding]::UTF8.GetBytes($criticalParams)
$req.ContentLength = $bytes.Length
$s = $req.GetRequestStream()
$s.Write($bytes, 0, $bytes.Length)
$s.Close()
$resp = $req.GetResponse()
$reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
$criticalResultHtml = $reader.ReadToEnd()
$resp.Close()

$isCritical = $criticalResultHtml.Contains("Critical") -and $criticalResultHtml.Contains($privateCity)
Record-Test "Analysis Engine" "Scenario B: Critical River Sample" $isCritical "Coliform & contaminants correctly triggered 'Critical' risk"

# Test 4.3: Out of range / Malformed input rejection
$badParams = "state=Karnataka&city=Bengaluru&pincode=000000&waterSource=InvalidSource&collectionDate=invalid-date" +
             "&latitude=999&longitude=999&ph=99&turbidity=-5&tds=999999&dissolvedOxygen=99" +
             "&temperature=999&hardness=99999&freeChlorine=99&coliformDetected=maybe"
try {
    $req = [System.Net.HttpWebRequest]::Create("$baseUrl/analyze")
    $req.Method = "POST"
    $req.ContentType = "application/x-www-form-urlencoded"
    $req.CookieContainer = $ownerJar
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($badParams)
    $req.ContentLength = $bytes.Length
    $s = $req.GetRequestStream()
    $s.Write($bytes, 0, $bytes.Length)
    $s.Close()
    $resp = $req.GetResponse()
    $resp.Close()
    Record-Test "Analysis Engine" "Malformed Parameters Rejected (HTTP 400)" $false "Server accepted out-of-range input"
} catch [System.Net.WebException] {
    $resp = $_.Exception.Response
    $is400 = ($resp -and [int]$resp.StatusCode -eq 400)
    if ($resp) { $resp.Close() }
    Record-Test "Analysis Engine" "Malformed Parameters Rejected (HTTP 400)" $is400 "Rejected out-of-bounds parameters with HTTP 400 Bad Request"
}

# ------------------------------------------------------------------------------
# SUITE 5: REGIONAL WATER MAP & PRIVACY POLICY
# ------------------------------------------------------------------------------
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/map")
$req.CookieContainer = $ownerJar
$resp = $req.GetResponse()
$reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
$mapHtml = $reader.ReadToEnd()
$resp.Close()
$mapPageOk = $mapHtml.Contains("india-water-map") -and $mapHtml.Contains("risk-filter")
Record-Test "Regional Map" "Map Interface Rendering" $mapPageOk "Map page loaded with Leaflet container and controls"

$req = [System.Net.HttpWebRequest]::Create("$baseUrl/map-data")
$req.CookieContainer = $ownerJar
$resp = $req.GetResponse()
$reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
$mapDataJson = $reader.ReadToEnd()
$resp.Close()

$hasSharedSample = $mapDataJson.Contains($sharedCity) -and $mapDataJson.Contains("12.9716")
$hidesPrivateSample = -not $mapDataJson.Contains($privateCity)
Record-Test "Regional Map" "Opt-in Shared Sample Exposed on Map" $hasSharedSample "Shared test sample ($sharedCity) appears in map data"
Record-Test "Regional Map" "Privacy Opt-out: Private Sample NOT Exposed" $hidesPrivateSample "Private test sample ($privateCity) is strictly hidden from map data"

# ------------------------------------------------------------------------------
# SUITE 6: LOGOUT & SESSION TERMINATION
# ------------------------------------------------------------------------------
$req = [System.Net.HttpWebRequest]::Create("$baseUrl/logout")
$req.Method = "POST"
$req.CookieContainer = $ownerJar
$req.AllowAutoRedirect = $false
$resp = $req.GetResponse()
$loc = $resp.Headers["Location"]
$resp.Close()
Record-Test "Session Lifecycle" "Logout Invalidation" ($loc -and $loc.Contains("logout=1")) "Session invalidated and redirected to login.html?logout=1"

$postLogoutBlock = Check-Redirect "$baseUrl/dashboard" "error=login-required"
Record-Test "Session Lifecycle" "Dashboard Blocked Post-Logout" $postLogoutBlock "Confirmed user cannot access dashboard after logout"

# ------------------------------------------------------------------------------
# SUMMARY & SCORECARD
# ------------------------------------------------------------------------------
Write-Host "`n==================================================================" -ForegroundColor Cyan
Write-Host "                  QA AUDIT SCORECARD & SUMMARY" -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan

$passedCount = ($results | Where-Object { $_.Status -eq "PASS" }).Count
$failedCount = ($results | Where-Object { $_.Status -eq "FAIL" }).Count
$totalCount  = $results.Count
$percentage  = [Math]::Round(($passedCount / $totalCount) * 100, 1)

Write-Host "Total Test Cases Executed : $totalCount"
Write-Host "Passed                   : $passedCount" -ForegroundColor Green
Write-Host "Failed                   : $failedCount" -ForegroundColor $(if ($failedCount -eq 0) { "Green" } else { "Red" })
Write-Host "Pass Rate                : $percentage%" -ForegroundColor $(if ($percentage -eq 100) { "Green" } else { "Yellow" })

if ($failedCount -eq 0) {
    Write-Host "`n[QA VERDICT: PASSED] Application meets 100% of functional, security, and quality requirements." -ForegroundColor Green
} else {
    Write-Host "`n[QA VERDICT: FAILED] Some test cases failed. Review test execution details." -ForegroundColor Red
}
Write-Host "==================================================================" -ForegroundColor Cyan
