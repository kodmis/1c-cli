.\build\set-globals.ps1

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

.\3dparty\1cv8.ps1 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString $env:_1CE_TargetDBConnection /CreateDistributionFiles -cffile "$env:DistributionDir\1cv8.cf"

if (Test-Path env:Extension1) {
  .\build\dump-ext.ps1 $env:Extension1
}

if (Test-Path env:Extension2) {
  .\build\dump-ext.ps1 $env:Extension2
}

if (Test-Path env:Extension3) {
  .\build\dump-ext.ps1 $env:Extension3
}