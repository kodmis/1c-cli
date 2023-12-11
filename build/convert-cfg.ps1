. $PSScriptRoot\before_script.ps1

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$RootDir="$PSScriptRoot\.."
pushd $RootDir

$SettingsObject = Get-Content -Path "settings.json" | ConvertFrom-Json
Write-Output "$(Get-Date): Start convert source of configuration"

$EDT_ProjectPath = "" + $SettingsObject.EDT_ProjectDir

$_1CE_ExportXML = ".build/xml"
if (Test-Path -Path "$_1CE_ExportXML") { Remove-Item -Recurse -Force "$_1CE_ExportXML"}

$EDTWorkspace = ".build/w"
if (Test-Path -Path "$EDTWorkspace") { Remove-Item -Recurse -Force "$EDTWorkspace"}

#set RING_OPTS=-Dfile.encoding=UTF-8
#if "%system_debug%"=="true" set RINGDEBUG=-l debug
Write-Output "$(Get-Date): Converting source of configuration from '$($EDT_ProjectPath.Replace('\', '/'))' to '$_1CE_ExportXML'"
ExecSafe { 1cedtcli -data "$EDTWorkspace" -timeout 3600 -command export --project "$($EDT_ProjectPath.Replace('\', '/'))" --configuration-files "$_1CE_ExportXML" }

if (-not(Test-Path -Path "$_1CE_ExportXML")) {
    throw "Not found converted source of configuration"
}
$stopwatch.Stop()
Write-Output "$(Get-Date): Finish convert source of configuration successfully in $([int] $stopwatch.Elapsed.TotalSeconds)"