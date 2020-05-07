if ($env:system_debug -eq "true") {
  $global:DebugPreference = "Continue"
} else {
  $global:DebugPreference = "SilentlyContinue"
}

$global:ErrorActionPreference = "Stop"

if (-not (Test-Path env:_1CE_Version)) {
  Write-Error "Error! Set _1CE_Version variable"
}

$_1CE_PATH = "C:\Program Files\1cv8\$env:_1CE_Version\bin"

if (-not (Test-Path $_1CE_PATH)) {
  $_1CE_PATH = "C:\Program Files (x86)\1cv8\$env:_1CE_Version\bin"
}

if (-not (Test-Path $_1CE_PATH)) {
  Write-Error "1C-Enterprise $env:_1CE_Version folder not found!"
}

# Find /I "DisableUnsafeActionProtection" "c:\Program Files (x86)\1cv8\conf\conf.cfg" 1>nul||Echo DisableUnsafeActionProtection=*>>"c:\Program Files (x86)\1cv8\conf\conf.cfg"

Write-Debug "Set $_1CE_PATH to PATH"
$env:PATH = "$_1CE_PATH;$env:PATH"
Write-Host "##vso[task.setvariable variable=PATH;]$env:PATH"
Remove-Variable _1CE_PATH