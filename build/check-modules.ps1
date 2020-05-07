.\build\set-globals.ps1

if (-not (Test-Path env:_1CE_TargetDBConnection)) {
  $env:_1CE_TargetDBConnection = "File='.db'"
}

.\3dparty\1cv8.ps1 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString $env:_1CE_TargetDBConnection /CheckModules -ThinClient -WebClient -Server -AllExtensions