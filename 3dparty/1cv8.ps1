Write-Debug "$ 1cv8 $args"

$LOGFILE = ".$(Get-Random).log"

Start-Process "1cv8.exe" -ArgumentList "$args /L en /Out $LOGFILE" -WindowStyle Minimized -Wait

if (-not $?) {
  Get-Content $LOGFILE | ForEach-Object { Write-Error $_ }
} else {
  Get-Content $LOGFILE | ForEach-Object { Write-Debug $_ }
}

if (Test-Path $LOGFILE) {
  Remove-Item -Path $LOGFILE -Recurse -Force
}