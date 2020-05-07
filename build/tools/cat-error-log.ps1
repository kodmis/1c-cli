if ($args[0] -eq "") {
  Write-Error "Call cat-error-log.ps1 error-log-file not-match-pattern-file [encoding]"
}

$ERROR_LOG = $args[0]
$NOT_MATCH_PATTERN = $args[1]
$ENCODING = $args[2]
$FILTERED_ERROR_LOG = "$(Get-Location)\tmp"

if ($ENCODING -eq "") {
  $ENCODING = "default"
}

if (-not (Test-Path $ERROR_LOG)) {
  Write-Error "Error! result file $ERROR_LOG not found"
}

if (Test-Path $NOT_MATCH_PATTERN) {
  $p = Get-Content $NOT_MATCH_PATTERN
  $res = Select-String -NotMatch -SimpleMatch -Pattern $p -Path $ERROR_LOG -Encoding $ENCODING;
  $res.Line > $FILTERED_ERROR_LOG
} else {
  Get-Content -Encoding $ENCODING $ERROR_LOG > $FILTERED_ERROR_LOG
}

if (Test-Path $FILTERED_ERROR_LOG) {
  $ERROR_COUNT = Get-Content $FILTERED_ERROR_LOG | Measure-Object | Select-Object -expand Count
}

if (-not ($ERROR_COUNT -eq 0)) {
  if (Test-Path $NOT_MATCH_PATTERN) {
    Write-Debug "There are strings, excluded from log:"
    Get-Content $NOT_MATCH_PATTERN
  }

  Remove-Item -Path $FILTERED_ERROR_LOG -Recurse

  Write-Debug "Found $ERROR_COUNT errors: "
  Write-Error (Get-Content -Encoding UTF8 $FILTERED_ERROR_LOG)
}

Write-Debug "Not found errors!"

if (Test-Path $NOT_MATCH_PATTERN) {
  Write-Debug "There are strings, excluded from log:"
  Get-Content $NOT_MATCH_PATTERN
}

Write-Debug "There is whole error log:"
Get-Content -Encoding $ENCODING $ERROR_LOG