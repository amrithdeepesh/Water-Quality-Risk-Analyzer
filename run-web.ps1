$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$tomcatHome = Join-Path $projectRoot '.tools\apache-tomcat-9.0.122'
$deployment = Join-Path $tomcatHome 'webapps\WaterQualityRiskAnalyzer'
$servletApi = Join-Path $tomcatHome 'lib\servlet-api.jar'
$webSource = Join-Path $projectRoot 'web'

if (-not (Test-Path -LiteralPath $servletApi)) {
    throw 'Tomcat 9 is missing. Install it under .tools\apache-tomcat-9.0.122 first.'
}
if (-not (Test-Path -LiteralPath $webSource)) {
    throw 'The project web folder is missing.'
}
$mysqlConnector = Join-Path $webSource 'WEB-INF\lib\mysql-connector-j-8.4.0.jar'
if (-not (Test-Path -LiteralPath $mysqlConnector)) {
    throw 'The MySQL Connector/J driver is missing from web\WEB-INF\lib.'
}

$compiler = Get-Command javac -ErrorAction Stop
$env:JAVA_HOME = Split-Path -Parent (Split-Path -Parent $compiler.Source)
if (-not (Test-Path -LiteralPath (Join-Path $env:JAVA_HOME 'bin\java.exe'))) {
    throw 'JAVA_HOME could not be determined from javac.'
}

$portUse = Get-NetTCPConnection -LocalPort 8081 -State Listen -ErrorAction SilentlyContinue
if ($portUse) {
    throw 'Port 8081 is already in use. Stop the other app before running this project.'
}

New-Item -ItemType Directory -Force -Path $deployment | Out-Null
Copy-Item -Path (Join-Path $webSource '*') -Destination $deployment -Recurse -Force
$classDirectory = Join-Path $deployment 'WEB-INF\classes'
New-Item -ItemType Directory -Force -Path $classDirectory | Out-Null
$sourceFiles = Get-ChildItem -Path (Join-Path $projectRoot 'src') -Recurse -Filter '*.java' | ForEach-Object { $_.FullName }

& javac --release 8 -Xlint:-options -classpath $servletApi -d $classDirectory $sourceFiles
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

$previousWqDbUser = $env:WQ_DB_USER
$previousWqDbPassword = $env:WQ_DB_PASSWORD
$passwordFile = Join-Path $projectRoot '.tools\water-db-password.dpapi'
$passwordPointer = $null
if (Test-Path -LiteralPath $passwordFile) {
    $encryptedPassword = Get-Content -LiteralPath $passwordFile -Raw
    $securePassword = ConvertTo-SecureString $encryptedPassword.Trim()
    $passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    $env:WQ_DB_USER = 'water_quality_app'
    $env:WQ_DB_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPointer)
}
$dbConfigured = -not [string]::IsNullOrWhiteSpace($env:WQ_DB_USER) -and
    -not [string]::IsNullOrWhiteSpace($env:WQ_DB_PASSWORD)
if ($dbConfigured) {
    Write-Output 'Database mode: MySQL'
} else {
    Write-Warning 'MySQL is not configured. The app will use temporary demo accounts and demo map data.'
}

$startup = Join-Path $tomcatHome 'bin\startup.bat'
try {
    Start-Process -FilePath 'C:\Windows\System32\cmd.exe' -ArgumentList @('/c', ('"' + $startup + '"')) -WorkingDirectory $tomcatHome -WindowStyle Hidden
} finally {
    $env:WQ_DB_USER = $previousWqDbUser
    $env:WQ_DB_PASSWORD = $previousWqDbPassword
    if ($passwordPointer) {
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($passwordPointer)
    }
}

$applicationUrl = 'http://localhost:8081/WaterQualityRiskAnalyzer/'
$ready = $false
for ($attempt = 0; $attempt -lt 30; $attempt++) {
    try {
        $null = Invoke-WebRequest -Uri $applicationUrl -UseBasicParsing -TimeoutSec 2
        $ready = $true
        break
    } catch {
        Start-Sleep -Seconds 1
    }
}
if (-not $ready) {
    throw 'Tomcat started, but the app did not answer yet. Check .tools\apache-tomcat-9.0.122\logs.'
}
Write-Output ('Water Quality Risk Analyzer is ready: ' + $applicationUrl)
