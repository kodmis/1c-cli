$Package = Get-Content -Path "package-lock.json" | ConvertFrom-Json
if (!$_1CE_Version) {  $_1CE_Version=$Package.dependencies.platform.version }
if ($_1CE_Version.Split(".").count -eq 3) { $_1CE_Version = "$_1CE_Version.????"}

$_1CE_PATH_64="C:\Program Files\1cv8"
$_1CE_PATH_32="C:\Program Files (x86)\1cv8"
$platforms = @()
if(Test-Path -Path $_1CE_PATH_32) {$platforms += Get-ChildItem "$_1CE_PATH_32\$_1CE_Version\bin"}
if(Test-Path -Path $_1CE_PATH_64) {$platforms += Get-ChildItem "$_1CE_PATH_64\$_1CE_Version\bin"}
if($platforms.count -eq 0) {echo "1C-Enterprise $_1CE_Version folder not found!"; exit 1}
$_1CE_PATH=$platforms[-1].FullName
echo "Founded 1C-Enterprise $_1CE_Version folder $_1CE_PATH"
$Env:PATH = "$_1CE_PATH;$Env:PATH"
