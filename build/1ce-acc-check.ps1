.\build\set-globals.ps1

if (-not (Test-Path env:EDT_ProjectDir_Configuration)) {
  Write-Error "Set EDT_ProjectDir_Configuration !"
}

$_1CE_ACCDir = ".acc"
$_1CE_ACCDBConnection = "File='$_1CE_ACCDir'"

if (Test-Path "$ROOT_DIR\$_1CE_ACCDir") {
  Remove-Item -Path "$ROOT_DIR\$_1CE_ACCDir" -Recurse
}

$env:EDT_ProjectPath = "$ROOT_DIR\$env:EDT_ProjectDir_Configuration"

.\3dparty\1cv8.ps1 CREATEINFOBASE $_1CE_ACCDBConnection

.\3dparty\1cv8.ps1 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString $_1CE_ACCDBConnection /LoadCfg ".\3dparty\automation-configuration-check.cf" /UpdateDBCfg

.\lint\gen-params.ps1 > $ROOT_DIR\$_1CE_ACCDir\.lint-params.xml

.\3dparty\1cv8.ps1 ENTERPRISE /WA- /DisableStartupDialogs /IBConnectionString $_1CE_ACCDBConnection /C $ROOT_DIR\$_1CE_ACCDir\.lint-params.xml