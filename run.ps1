$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputDirectory = Join-Path $projectRoot 'out'
$servletApi = Join-Path $projectRoot '.tools\apache-tomcat-9.0.122\lib\servlet-api.jar'

New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$sourceFiles = Get-ChildItem -Path (Join-Path $projectRoot 'src') -Recurse -Filter '*.java' |
    ForEach-Object { $_.FullName }

$classpath = $outputDirectory
if (Test-Path -LiteralPath $servletApi) {
    $classpath = "$outputDirectory;$servletApi"
}

& javac --release 8 -Xlint:-options -classpath $classpath -d $outputDirectory $sourceFiles
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& java -cp $classpath com.waterquality.main.Main
exit $LASTEXITCODE
