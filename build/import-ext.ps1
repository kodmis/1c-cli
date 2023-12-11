. $PSScriptRoot\before_script.ps1

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$RootDir="$PSScriptRoot\.."
pushd $RootDir

$ExtensionName = $args[0]
Write-Output "$(Get-Date): Start import source of extension '$ExtensionName'"

$_1CE_TargetDB = "$RootDir/.db"
$_1CE_ExportXML = ".build/xml-$ExtensionName"
if (-not (Test-Path -Path "$_1CE_ExportXML")) { throw "Not found converted sources of extension $ExtensionName"}
if (-not (Test-Path -Path "$_1CE_TargetDB")) { throw "Not found target DB"}

Write-Output "$(Get-Date): Importing source of extension '$ExtensionName' from '$_1CE_ExportXML' to DB '$_1CE_TargetDB'"
ExecSafe { ibcmd.exe infobase config import --data="$_1CE_TargetDB\srv" --db-path="$_1CE_TargetDB" --extension=$ExtensionName "$_1CE_ExportXML" }
ExecSafe { ibcmd.exe infobase config apply --data="$_1CE_TargetDB\srv" --db-path="$_1CE_TargetDB" --extension=$ExtensionName --force }
ExecSafe { ibcmd.exe infobase config extension update --data="$_1CE_TargetDB\srv" --db-path="$_1CE_TargetDB" --name=$ExtensionName --safe-mode=no --unsafe-action-protection=no }
$stopwatch.Stop()
Write-Output "$(Get-Date): Finish import source of extension '$ExtensionName' successfully in $([int] $stopwatch.Elapsed.TotalSeconds)"
