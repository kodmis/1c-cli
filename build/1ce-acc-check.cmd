@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

SETLOCAL
chcp 65001 >nul
set ROOT_DIR=%~dp0\..\

IF NOT DEFINED EDT_ProjectDir_Configuration (
  echo Set EDT_ProjectDir_Configuration ! 1>&2
  exit /b 1
)

set _1CE_ACCDir=.acc
set _1CE_ACCDBConnection="File='%_1CE_ACCDir%'"

set EDT_ProjectPath=%ROOT_DIR%\%EDT_ProjectDir_Configuration%

pushd %ROOT_DIR%

call .\3dparty\1cv8 CREATEINFOBASE %_1CE_ACCDBConnection%
IF ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

call .\3dparty\1cv8 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString %_1CE_ACCDBConnection% /LoadCfg ".\3dparty\automation-configuration-check.cf" /UpdateDBCfg
IF ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

call .\lint\gen-params.cmd > %ROOT_DIR%\%_1CE_ACCDir%\.lint-params.xml
call .\3dparty\1cv8 ENTERPRISE /WA- /DisableStartupDialogs /IBConnectionString %_1CE_ACCDBConnection% /C %ROOT_DIR%\%_1CE_ACCDir%\.lint-params.xml
IF ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

popd