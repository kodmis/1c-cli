@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

SETLOCAL
set ROOT_DIR=%~dp0\..\

IF NOT DEFINED _1CE_TargetDBConnection (
  set _1CE_TargetDBConnection="File='.db'"
)

pushd %ROOT_DIR%

call .\3dparty\1cv8 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString %_1CE_TargetDBConnection% /CheckModules -ThinClient -WebClient -Server -AllExtensions
set _1CE_StartResult=%ERRORLEVEL%

popd

exit /b %_1CE_StartResult%