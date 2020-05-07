Write-Debug "$ 1cv8 $args /Out 1cv8.log"

$LOGFILE = "$(Get-Location)\1cv8.log"

Start-Process "1cv8.exe" -ArgumentList "$args /L en /Out $LOGFILE" -WindowStyle Minimized -Wait

if (-not $?) {
  Get-Content $LOGFILE | ForEach-Object { Write-Error $_ }
}