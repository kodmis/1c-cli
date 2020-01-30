@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

SETLOCAL
chcp 65001 >nul
set ROOT_DIR=%~dp0\..\

IF NOT DEFINED EDT_ProjectDir_Configuration (
  echo Error! Set EDT_ProjectDir_Configuration variable 1>&2
  exit /b 1
)

SET project-list="%ROOT_DIR%\%EDT_ProjectDir_Configuration%"
IF DEFINED Extension1 (
  SET project-list=%project-list% "%ROOT_DIR%\%EDT_ProjectDir_Extension1%"
)
IF DEFINED Extension2 (
  SET project-list=%project-list% "%ROOT_DIR%\%EDT_ProjectDir_Extension2%"
)
IF DEFINED Extension3 (
  SET project-list=%project-list% "%ROOT_DIR%\%EDT_ProjectDir_Extension3%"
)

IF NOT DEFINED EDT_ValidationResult (
  set EDT_ValidationResult=%ROOT_DIR%\validation.tsv
)

pushd %ROOT_DIR%

if exist "%EDT_ValidationResult%" (
  del /f /s /q "%EDT_ValidationResult%" > nul
)

call .\3dparty\ring validate --project-list %project-list% --file "%EDT_ValidationResult%"

popd

call .\build\tools\cat-error-log "%EDT_ValidationResult%" ".\build\config\exclude-validate" UTF8
IF ERRORLEVEL 1 (
  exit /b 1
) ELSE (
  exit /b
)