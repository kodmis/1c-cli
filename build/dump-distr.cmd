@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

SETLOCAL
chcp 65001 >nul
set ROOT_DIR=%~dp0\..\

IF NOT DEFINED DistributionDir (
  set DistributionDir=dist
)

IF NOT DEFINED _1CE_TargetDBConnection (
  set _1CE_TargetDBConnection="File='.db'"
)

pushd %ROOT_DIR%

call .\3dparty\1cv8 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString %_1CE_TargetDBConnection% /CreateDistributionFiles -cffile "%DistributionDir%\1cv8.cf"
IF ERRORLEVEL 1 (
  exit /b 1
)

IF DEFINED Extension1 (
  call .\build\dump-ext.cmd %Extension1%
)
IF DEFINED Extension2 (
  call .\build\dump-ext.cmd %Extension2%
)
IF DEFINED Extension3 (
  call .\build\dump-ext.cmd %Extension3%
)

popd