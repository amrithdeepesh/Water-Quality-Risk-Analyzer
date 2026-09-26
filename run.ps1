$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$outputDirectory = Join-Path $projectRoot 'out'

New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

# The installed runtime is Java 8, so generate Java-8-compatible class files
# even when a newer JDK supplies javac.
$sourceFiles = Get-ChildItem -Path (Join-Path $projectRoot 'src') -Recurse -Filter '*.java' |
    ForEach-Object { $_.FullName }

& javac --release 8 -Xlint:-options -d $outputDirectory $sourceFiles
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& java -cp $outputDirectory com.waterquality.main.Main
exit $LASTEXITCODE
