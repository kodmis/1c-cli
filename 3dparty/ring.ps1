Write-Debug "$ ring $args"

if (-not (Test-Path env:EDT_WORKSPACE)) {
  $env:EDT_WORKSPACE = "$(Get-Location)\.w"
}

$EDT_WORKSPACE = $env:EDT_WORKSPACE

if (Test-Path $EDT_WORKSPACE) {
  Remove-Item -Path $EDT_WORKSPACE -Recurse
}

$env:RING_OPTS = "-Dfile.encoding=UTF-8"

if ($env:system_debug -eq "true") {
  $env:RINGDEBUG = "debug"
} else {
  $env:RINGDEBUG = "error"
}

ring -l $env:RINGDEBUG edt workspace $args --workspace-location $EDT_WORKSPACE

if (-not $?) {
  Write-Error "ring error"
}