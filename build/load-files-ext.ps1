if ($args[0] -eq "") {
  Write-Error "Call load-files-ext.ps1 EDT-project-folder-name 1CE-extension-name"
}

if (-not (Test-Path env:_1CE_TargetDBConnection)) {
  $env:_1CE_TargetDBConnection = "File='.db'"
}

$EDT_ProjectPath = "$ROOT_DIR\$($args[0])"

$_1CE_ExtensionName = $args[1]

if (-not (Test-Path env:_1CE_ExportXML)) {
  $env:_1CE_ExportXML = "$ROOT_DIR\.xml"
}

$_1CE_ExportXML = $env:_1CE_ExportXML

if (Test-Path $_1CE_ExportXML) {
  Remove-Item -Path $_1CE_ExportXML -Recurse
}

.\3dparty\ring.ps1 export --project $EDT_ProjectPath --configuration-files $env:_1CE_ExportXML

.\3dparty\1cv8.ps1 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString $env:_1CE_TargetDBConnection /LoadConfigFromFiles $env:_1CE_ExportXML -Extension $_1CE_ExtensionName /UpdateDBCfg