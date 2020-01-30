@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

SETLOCAL
chcp 65001 >nul
set ROOT_DIR=%~dp0\..\

if "%1" EQU "" (
  echo Call dump-ext.cmd 1CE-extension-name 1>&2
  exit /b 1
)
set _1CE_ExtensionName=%1

IF NOT DEFINED DistributionDir (
  set DistributionDir=dist
)

IF NOT DEFINED _1CE_TargetDBConnection (
  set _1CE_TargetDBConnection="File='.db'"
)

pushd %ROOT_DIR%

call .\3dparty\1cv8 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString %_1CE_TargetDBConnection% /DumpCfg "%DistributionDir%\%_1CE_ExtensionName%.cfe" -Extension %_1CE_ExtensionName%
IF ERRORLEVEL 1 (
  exit /b 1
)

popd