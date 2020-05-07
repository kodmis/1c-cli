if ($args[0] -eq "") {
  Write-Error "Call dump-ext.ps1 1CE-extension-name"
}

$_1CE_ExtensionName = $args[0]

if (-not (Test-Path env:DistributionDir)) {
  $env:DistributionDir = "dist"
}

$DistributionDir = "$ROOT_DIR\$env:DistributionDir"

if (-not (Test-Path $DistributionDir)) {
  New-Item -Path $DistributionDir -ItemType directory | Out-Null
}

if (-not (Test-Path env:_1CE_TargetDBConnection)) {
  $env:_1CE_TargetDBConnection = "File='.db'"
}

.\3dparty\1cv8.ps1 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString $env:_1CE_TargetDBConnection /DumpCfg "$env:DistributionDir\$_1CE_ExtensionName.cfe" -Extension $_1CE_ExtensionName