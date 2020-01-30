@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

IF NOT DEFINED _1CE_Version (
  echo Error! Set _1CE_Version variable 1>&2
  exit /b 1
)

set _1CE_PATH="C:\Program Files\1cv8\%_1CE_Version%\bin"

if not exist %_1CE_PATH% (
  set _1CE_PATH="C:\Program Files (x86)\1cv8\%_1CE_Version%\bin"
)
if not exist %_1CE_PATH% (
  echo 1C-Enterprise %_1CE_Version% folder not found ! 1>&2
  exit /b 1
)
::Find /I "DisableUnsafeActionProtection" "c:\Program Files (x86)\1cv8\conf\conf.cfg" 1>nul||Echo DisableUnsafeActionProtection=*>>"c:\Program Files (x86)\1cv8\conf\conf.cfg"

echo Set %_1CE_PATH% to PATH
set PATH=%_1CE_PATH%;%PATH%
set _1CE_PATH=

