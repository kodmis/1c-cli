. $PSScriptRoot\before_script.ps1

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$RootDir="$PSScriptRoot\.."
pushd $RootDir

Write-Output "$(Get-Date): Start import source of configuration"
$_1CE_ExportXML = ".build/xml"
$_1CE_TargetDB = "$RootDir/.db"
if (Test-Path -Path "$_1CE_TargetDB") { Remove-Item -Recurse -Force "$_1CE_TargetDB"}

Write-Output "$(Get-Date): Importing source of configuration from '$_1CE_ExportXML' to DB '$_1CE_TargetDB'"
ExecSafe { ibcmd.exe infobase create --data="$_1CE_TargetDB\srv" --db-path="$_1CE_TargetDB" --import="$_1CE_ExportXML" --apply --force }
$stopwatch.Stop()
Write-Output "$(Get-Date): Finish import source of configuration successfully in $([int] $stopwatch.Elapsed.TotalSeconds)"
