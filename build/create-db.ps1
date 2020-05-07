.\build\set-globals.ps1

if (-not (Test-Path env:EDT_ProjectDir_Configuration)) {
  Write-Error "Set EDT_ProjectDir_Configuration !"
}

$EDT_ProjectPath = "$ROOT_DIR\$env:EDT_ProjectDir_Configuration"

if (-not (Test-Path env:_1CE_ExportXML)) {
  $env:_1CE_ExportXML = "$ROOT_DIR\.xml"
}

$_1CE_ExportXML = $env:_1CE_ExportXML

if (Test-Path $_1CE_ExportXML) {
  Remove-Item -Path $_1CE_ExportXML -Recurse
}

.\3dparty\ring.ps1 export --project $EDT_ProjectPath --configuration-files $env:_1CE_ExportXML

$_1CE_DBDir = ".db"

if (-not (Test-Path env:_1CE_TargetDBConnection)) {
  $env:_1CE_TargetDBConnection = "File='$_1CE_DBDir'"
}

if (Test-Path "$ROOT_DIR\$_1CE_DBDir") {
  Remove-Item -Path "$ROOT_DIR\$_1CE_DBDir" -Recurse
}

.\3dparty\1cv8.ps1 CREATEINFOBASE $env:_1CE_TargetDBConnection

.\3dparty\1cv8.ps1 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString $env:_1CE_TargetDBConnection /LoadConfigFromFiles $env:_1CE_ExportXML /UpdateDBCfg

if (Test-Path env:Extension1) {
  .\build\load-files-ext.ps1 $env:EDT_ProjectDir_Extension1 $env:Extension1
}

if (Test-Path env:Extension2) {
  .\build\load-files-ext.ps1 $env:EDT_ProjectDir_Extension2 $env:Extension2
}

if (Test-Path env:Extension3) {
  .\build\load-files-ext.ps1 $env:EDT_ProjectDir_Extension3 $env:Extension3
}

.\3dparty\1cv8.ps1 ENTERPRISE /WA- /DisableStartupDialogs /IBConnectionString $env:_1CE_TargetDBConnection /C ВыполнитьОбновлениеИЗавершитьРаботу

.\3dparty\1cv8.ps1 ENTERPRISE /WA- /DisableStartupDialogs /IBConnectionString $env:_1CE_TargetDBConnection /C "Extensions=$env:Extension1,$env:Extension2,$env:Extension3" /Execute 3dparty\install-extension.epf