. $PSScriptRoot\before_script.ps1

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$RootDir="$PSScriptRoot\.."
pushd $RootDir

$SettingsObject = Get-Content -Path "settings.json" | ConvertFrom-Json
$ExtensionName = $args[0]
Write-Output "$(Get-Date): Start convert source of extension '$ExtensionName'"

$EDT_ProjectPath = ""
foreach ($extension in $SettingsObject.Extensions) {
    if ($extension.name -eq $ExtensionName) {
        $EDT_ProjectPath = $extension.EDT_ProjectDir
        break
    }
}
if ($EDT_ProjectPath -eq "") { throw "Can't convert source of extension. Not correct extension name '$ExtensionName'"}

$_1CE_ExportXML = ".build/xml-$ExtensionName"
if (Test-Path -Path "$_1CE_ExportXML") { Remove-Item -Recurse -Force "$_1CE_ExportXML"}
$EDTWorkspace = ".build/w-$ExtensionName"
if (Test-Path -Path "$EDTWorkspace") { Remove-Item -Recurse -Force "$EDTWorkspace"}

#set RING_OPTS=-Dfile.encoding=UTF-8
#if "%system_debug%"=="true" set RINGDEBUG=-l debug
Write-Output "$(Get-Date): Converting source of extension '$ExtensionName' from '$($EDT_ProjectPath.Replace('\', '/'))' to '$_1CE_ExportXML'"
ExecSafe { 1cedtcli -data "$EDTWorkspace" -timeout 1800 -command export --project "$($EDT_ProjectPath.Replace('\', '/'))" --configuration-files "$_1CE_ExportXML" }

if (-not(Test-Path -Path "$_1CE_ExportXML")) {
    throw "Not found converted source extension '$ExtensionName'"
}
$stopwatch.Stop()
Write-Output "$(Get-Date): Finish convert source of extension '$ExtensionName' successfully  in $([int] $stopwatch.Elapsed.TotalSeconds)"