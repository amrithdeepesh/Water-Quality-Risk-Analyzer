$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$tomcatHome = Join-Path $projectRoot '.tools\apache-tomcat-9.0.122'
$compiler = Get-Command javac -ErrorAction Stop
$env:JAVA_HOME = Split-Path -Parent (Split-Path -Parent $compiler.Source)
$env:CATALINA_HOME = $tomcatHome

$passwordFile = Join-Path $projectRoot '.tools\water-db-password.dpapi'
if (Test-Path -LiteralPath $passwordFile) {
    $encryptedPassword = Get-Content -LiteralPath $passwordFile -Raw
    $securePassword = ConvertTo-SecureString $encryptedPassword.Trim()
    $passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    $env:WQ_DB_USER = 'water_quality_app'
    $env:WQ_DB_PASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($passwordPointer)
}

& "$tomcatHome\bin\catalina.bat" run
