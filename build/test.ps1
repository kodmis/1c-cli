. $PSScriptRoot\before_script.ps1

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$RootDir="$PSScriptRoot\.."
pushd $RootDir

$TestRunner = $args[0]
if ($TestRunner -eq "va") {
    .\build\test-va.ps1
    exit $LastExitCode
}
$SettingsObject = Get-Content -Path "settings.json" | ConvertFrom-Json

Write-Output "$(Get-Date): Start run unit tests"

$UnitTestExtension = $SettingsObject.UnitTests.Extension
.\build\convert-ext.ps1 $UnitTestExtension
.\build\import-ext.ps1 $UnitTestExtension

$_1CE_TargetDB = "$RootDir/.db"
$UsingTestConfig="./.test/unit/test-config.json"
New-Item -Force -ItemType "directory" ".test/unit" | Out-Null
$RootDir=$RootDir -replace "\\", "/"
$ExecutionContext.InvokeCommand.ExpandString($(Get-Content "$($SettingsObject.UnitTests.Config)")) | Out-File -FilePath "$UsingTestConfig"
$TestSettingsObject = Get-Content -Path "$UsingTestConfig" | ConvertFrom-Json

Write-Output "$(Get-Date): Running test on DB '$_1CE_TargetDB' with config at '$RootDir/$UsingTestConfig'"
Exec1cv8 { 1cv8.exe ENTERPRISE /WA- /DisableStartupDialogs /F "$_1CE_TargetDB" /C "RunUnitTests=$RootDir/$UsingTestConfig" }
$ExitCodeFile = $TestSettingsObject.exitCode
if (Test-Path -Path "$ExitCodeFile") {
    $exitCode = [int] $(Get-Content "$ExitCodeFile") 
} else {
    $exitCode = 0
}
$LogFile = $TestSettingsObject.logging.file
if (Test-Path -Path "$LogFile") { 
    Get-Content $LogFile | Write-Host
}

$stopwatch.Stop()
if ($exitCode -eq 0) {
    Write-Output "$(Get-Date): Complete run unit tests in $([int] $stopwatch.Elapsed.TotalSeconds)"
} else {
    Write-Output "$(Get-Date): Finish run unit tests in $([int] $stopwatch.Elapsed.TotalSeconds)"
    exit $exitCode
}

