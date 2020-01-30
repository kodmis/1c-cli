@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off
SETLOCAL
chcp 65001 >nul

if "%1" EQU "" (
  echo Call cat-error-log.cmd error-log-file not-match-pattern-file [encoding] 1>&2
  exit /b 1
)

set ERROR_LOG=%1
set NOT_MATCH_PATTERN=%2
set ENCODING=%3
set FILTERED_ERROR_LOG=%CD%\tmp

if "%ENCODING%"=="" (
  set ENCODING=default
)
if NOT exist "%ERROR_LOG%" (
  echo Error! result file %ERROR_LOG% not found 1>&2
  exit /b 1
)

if exist "%NOT_MATCH_PATTERN%" (
  powershell $p = cat "%NOT_MATCH_PATTERN%" ; $res = sls -NotMatch -SimpleMatch -Pattern $p -Path "%ERROR_LOG%" -Encoding %ENCODING% ; $res.Line > %FILTERED_ERROR_LOG%
) ELSE (
  powershell cat -Encoding %ENCODING% "%ERROR_LOG%" > %FILTERED_ERROR_LOG%
) 

if exist "%FILTERED_ERROR_LOG%" (
  for /F "tokens=3" %%i IN ('find /v /c "" %FILTERED_ERROR_LOG%') DO set ERROR_COUNT=%%i
)

if NOT "%ERROR_COUNT%"=="0" (
  echo Found %ERROR_COUNT% errors: 1>&2
  powershell cat -Encoding UTF8 %FILTERED_ERROR_LOG% 1>&2
  if exist "%NOT_MATCH_PATTERN%" (
    echo.
    echo There are strings, excluded from log:
    powershell cat "%NOT_MATCH_PATTERN%"
  )
  del /f /s /q %FILTERED_ERROR_LOG% > nul
  exit /b 1
)

echo Not found errors!
if exist "%NOT_MATCH_PATTERN%" (
  echo.
  echo There are strings, excluded from log:
  powershell cat "%NOT_MATCH_PATTERN%"
)
echo.
echo There is whole error log:
powershell cat -Encoding %ENCODING% %ERROR_LOG%

exit /b
