@if "%system_debug%"=="true" echo on
@if "%system_debug%"=="false" echo off
echo $ 1cv8 %*

SETLOCAL

set LOGFILE=.%random%.log
1cv8.exe %* /L en /Out %LOGFILE%
set _1CE_StartResult=%ERRORLEVEL%

if /I %_1CE_StartResult% GTR 0 (
  powershell -Command Get-Content %LOGFILE% 1>&2
) ELSE (
  powershell -Command Get-Content %LOGFILE%
)

if exist %LOGFILE% (
  del /f /s /q %LOGFILE% > nul
)

exit /b %_1CE_StartResult%