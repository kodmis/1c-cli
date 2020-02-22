@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

SETLOCAL
set ROOT_DIR=%~dp0\..\

IF NOT DEFINED _1CE_TargetDBConnection (
  set _1CE_TargetDBConnection="File='.db'"
)

pushd %ROOT_DIR%

SET VANESSA_featurepath=%_1CE_TestUnitDir%
call .\3dparty\1cv8 ENTERPRISE /WA- /DisableStartupDialogs /IBConnectionString %_1CE_TargetDBConnection% /Execute .\3dparty\vanessa-automation-single.epf /C"StartFeaturePlayer;workspaceRoot=%CD%;VBParams=%CD%\test\unit\vanessa-conf.json"
IF ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

popd
