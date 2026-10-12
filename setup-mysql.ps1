$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$mysqlCommand = Get-Command mysql -ErrorAction SilentlyContinue
if ($mysqlCommand) {
    $mysqlExe = $mysqlCommand.Source
} else {
    $mysqlExe = 'C:\laragon\bin\mysql\mysql-8.0.30-winx64\bin\mysql.exe'
}
if (-not (Test-Path -LiteralPath $mysqlExe)) {
    throw 'MySQL client not found. Add mysql.exe to PATH or install MySQL/Laragon.'
}

$adminUser = Read-Host 'MySQL administrator username (usually root)'
if ([string]::IsNullOrWhiteSpace($adminUser)) { $adminUser = 'root' }
$adminSecure = Read-Host 'MySQL administrator password' -AsSecureString
$adminPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($adminSecure)
$adminPassword = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($adminPointer)

try {
    $env:MYSQL_PWD = $adminPassword
    $schemaPath = Join-Path $projectRoot 'database\schema.sql'
    $schemaPath = $schemaPath.Replace('\', '/')
    & $mysqlExe "--user=$adminUser" --host=127.0.0.1 --port=3306 --default-character-set=utf8mb4 "--execute=SOURCE $schemaPath;"
    if ($LASTEXITCODE -ne 0) {
        throw 'Schema setup failed. Check your MySQL username, password, and service.'
    }

    $characters = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789'
    $randomBytes = New-Object byte[] 48
    [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($randomBytes)
    $appPassword = -join ($randomBytes | ForEach-Object {
        $characters[[int]($_ % $characters.Length)]
    })
    $appUser = 'water_quality_app'
    $accountSql = "CREATE USER IF NOT EXISTS '$appUser'@'localhost' IDENTIFIED BY '$appPassword';"
    $accountSql += " ALTER USER '$appUser'@'localhost' IDENTIFIED BY '$appPassword';"
    $accountSql += " CREATE USER IF NOT EXISTS '$appUser'@'127.0.0.1' IDENTIFIED BY '$appPassword';"
    $accountSql += " ALTER USER '$appUser'@'127.0.0.1' IDENTIFIED BY '$appPassword';"
    $accountSql += " GRANT SELECT,INSERT,UPDATE,DELETE ON water_quality_analyzer.* TO '$appUser'@'localhost';"
    $accountSql += " GRANT SELECT,INSERT,UPDATE,DELETE ON water_quality_analyzer.* TO '$appUser'@'127.0.0.1';"
    & $mysqlExe "--user=$adminUser" --host=127.0.0.1 --port=3306 "--execute=$accountSql"
    if ($LASTEXITCODE -ne 0) {
        throw 'The database was created, but the application account could not be set up.'
    }

    $secureAppPassword = ConvertTo-SecureString $appPassword -AsPlainText -Force
    $encryptedPassword = ConvertFrom-SecureString $secureAppPassword
    $toolsDirectory = Join-Path $projectRoot '.tools'
    New-Item -ItemType Directory -Force -Path $toolsDirectory | Out-Null
    Set-Content -LiteralPath (Join-Path $toolsDirectory 'water-db-password.dpapi') -Value $encryptedPassword -Encoding ASCII

    Write-Output 'MySQL is ready. The app password is stored encrypted for this Windows account under .tools.'
    Write-Output 'Next, stop any old Tomcat session and run .\run-web.ps1.'
} finally {
    $env:MYSQL_PWD = $null
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($adminPointer)
}
