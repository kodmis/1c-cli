@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off

chcp 65001 >nul
set ROOT_DIR=%~dp0

pushd %ROOT_DIR%

call ./.env.cmd
call ./3dparty/init-1ce.cmd
call ./build/dump-distr.cmd

popd