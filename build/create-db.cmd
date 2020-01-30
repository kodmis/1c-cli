@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

SETLOCAL
chcp 65001 >nul
set ROOT_DIR=%~dp0\..\

IF NOT DEFINED EDT_ProjectDir_Configuration (
  echo Set EDT_ProjectDir_Configuration ! 1>&2
  exit /b 1
)

IF NOT DEFINED _1CE_TargetDBConnection (
  set _1CE_TargetDBConnection="File='.db'"
)

set EDT_ProjectPath=%ROOT_DIR%\%EDT_ProjectDir_Configuration%

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

call .\3dparty\1cv8 CREATEINFOBASE %_1CE_TargetDBConnection%
IF ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

call .\3dparty\1cv8 DESIGNER /WA- /DisableStartupDialogs /IBConnectionString %_1CE_TargetDBConnection% /LoadConfigFromFiles "%_1CE_ExportXML%" /UpdateDBCfg
IF ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

IF DEFINED Extension1 (
  call .\build\load-files-ext.cmd %EDT_ProjectDir_Extension1% %Extension1%
)
IF DEFINED Extension2 (
  call .\build\load-files-ext.cmd %EDT_ProjectDir_Extension2% %Extension2%
)
IF DEFINED Extension3 (
  call .\build\load-files-ext.cmd %EDT_ProjectDir_Extension3% %Extension3%
)

call .\3dparty\1cv8 ENTERPRISE /WA- /DisableStartupDialogs /IBConnectionString %_1CE_TargetDBConnection% /C ВыполнитьОбновлениеИЗавершитьРаботу
IF ERRORLEVEL 1 (
  popd
  exit /b %ERRORLEVEL%
)

popd