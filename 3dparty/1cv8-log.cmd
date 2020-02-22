@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

SETLOCAL
IF NOT DEFINED _1CE_Log (
  set _1CE_Log=1cv8.log
)
echo $ 1cv8 %* /Out %_1CE_Log%

1cv8.exe %* /L en /Out %_1CE_Log%
set _1CE_StartResult=%ERRORLEVEL%

exit /b %_1CE_StartResult%