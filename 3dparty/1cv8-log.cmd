@if "%system_debug%"=="false" echo off
echo $ 1cv8 %* /Out 1cv8.log

1cv8.exe %* /L en /Out %CD%\1cv8.log
set _1CE_StartResult=%ERRORLEVEL%

exit /b %_1CE_StartResult%