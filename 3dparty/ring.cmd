@if "%system_debug%"=="true" echo on
@if NOT "%system_debug%"=="true" echo off
echo $ ring %*

SETLOCAL
IF NOT DEFINED EDT_WORKSPACE (
  set EDT_WORKSPACE=%CD%\.w
)

if exist "%EDT_WORKSPACE%" (
  rmdir /S /Q "%EDT_WORKSPACE%" > nul
)

set RING_OPTS=-Dfile.encoding=UTF-8
if "%system_debug%"=="true" set RINGDEBUG=-l debug

call ring %RINGDEBUG% edt workspace %* --workspace-location "%EDT_WORKSPACE%"
IF ERRORLEVEL 1 exit /b %ERRORLEVEL%
if "%system_debug%"=="true" echo on

::export --project "%Build_SourcesDirectory%/%EDT_ProjectName%" --configuration-files "%Build_ArtifactStagingDirectory%/xml"
::validate --project-list "%Build_SourcesDirectory%/%EDT_ProjectName%" --file "%Build_ArtifactStagingDirectory%/validation.tsv"

exit /b