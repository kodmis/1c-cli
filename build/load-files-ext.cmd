@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

SETLOCAL
chcp 65001 >nul
set ROOT_DIR=%~dp0\..\

if "%1" EQU "" (
  echo Call load-files-ext.cmd EDT-project-folder-name 1CE-extension-name 1>&2
  exit /b 1
)

IF NOT DEFINED _1CE_TargetDBConnection (
  set _1CE_TargetDBConnection="File='.db'"
)

set EDT_ProjectPath="%ROOT_DIR%\%1"
set _1CE_ExtensionName=%2

IF NOT DEFINED _1CE_ExportXML (
  set _1CE_ExportXML=%ROOT_DIR%\.xml
)

pushd %ROOT_DIR%

if exist "%_1CE_ExportXML%" (
  rmdir /S /Q "%_1CE_ExportXML%" > nul
)

call .\3dparty\ring export --project %EDT_ProjectPath% --configuration-files "%_1CE_ExportXML%"
IF ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)
call .\3dparty\1cv8 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString %_1CE_TargetDBConnection% /LoadConfigFromFiles "%_1CE_ExportXML%" -Extension %_1CE_ExtensionName% /UpdateDBCfg
IF ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

popd