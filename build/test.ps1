.\build\set-globals.ps1

if (-not (Test-Path env:_1CE_TargetDBConnection)) {
  $env:_1CE_TargetDBConnection = "File='.db'"
}

$env:VANESSA_featurepath = $env:_1CE_TestUnitDir

.\3dparty\1cv8.ps1 ENTERPRISE /WA- /DisableStartupDialogs /IBConnectionString $env:_1CE_TargetDBConnection /Execute .\3dparty\vanessa-automation-single.epf /C "StartFeaturePlayer;workspaceRoot=$(Get-Location);VBParams=$(Get-Location)\test\unit\vanessa-conf.json"