. $PSScriptRoot\before_script.ps1

Write-Output "Disabled unsafe action protection"
$SettingsObject = Get-Content -Path "$PSScriptRoot\..\settings.json" | ConvertFrom-Json
$OneCiConfFile="$Env:ProgramFiles\1cv8\conf\conf.cfg"
#Write-Output SystemLanguage=System > "%OneCiConfFile%"
#Write-Output DisableUnsafeActionProtection=File=.*>>"%OneCiConfFile%"
if (-not (Select-String -Path $OneCiConfFile -SimpleMatch "DisableUnsafeActionProtection" -Quiet)) { Out-File $OneCiConfFile -Append -InputObject "`nDisableUnsafeActionProtection=File=.*"}

