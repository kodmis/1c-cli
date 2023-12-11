. $PSScriptRoot\before_script.ps1

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$RootDir="$PSScriptRoot\.."
pushd $RootDir

Write-Output "$(Get-Date): Start dump configuration"
$SettingsObject = Get-Content -Path "settings.json" | ConvertFrom-Json
$_1CE_TargetDB = "$RootDir\.db"
$DistributionDir = "dist"
if (-not (Test-Path -Path "$_1CE_TargetDB")) { throw "Not found target DB"}
New-Item -Force -ItemType "directory" "$DistributionDir" | Out-Null

Write-Output "$(Get-Date): Dumping configuration from DB '$_1CE_TargetDB' to file '$DistributionDir\1cv8.cf'"
ExecSafe { ibcmd.exe infobase config save --data="$_1CE_TargetDB\srv" --db-path="$_1CE_TargetDB" "$DistributionDir\1cv8.cf" }

foreach ($extension in $SettingsObject.Build.Extensions) {
    Write-Output "$(Get-Date): Dumping extension $extension from DB '$_1CE_TargetDB' to file '$DistributionDir\$extension.cfe'"
    ExecSafe { ibcmd.exe infobase config save --data="$_1CE_TargetDB\srv" --db-path="$_1CE_TargetDB" --extension="$extension" "$DistributionDir\$extension.cfe" }
}
$stopwatch.Stop()
Write-Output "$(Get-Date): Finish dump configuration successfully in $([int] $stopwatch.Elapsed.TotalSeconds)"
