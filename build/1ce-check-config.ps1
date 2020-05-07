.\build\set-globals.ps1

if (-not (Test-Path env:_1CE_TargetDBConnection)) {
  $env:_1CE_TargetDBConnection = "File='.db'"
}

$_1CE_CheckConfigResult = "$(Get-Location)\1cv8.log"

.\3dparty\1cv8-log.ps1 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString $env:_1CE_TargetDBConnection /CheckConfig -IncorrectReferences -ThinClient -WebClient -Server -ExtendedModulesCheck -CheckUseSyncronousCalls -CheckUseModality -AllExtensions

.\build\tools\cat-error-log.ps1 $_1CE_CheckConfigResult ".\build\config\exclude-check-config" Default