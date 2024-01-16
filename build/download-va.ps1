. $PSScriptRoot\before_script.ps1

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$RootDir="$PSScriptRoot\.."
pushd $RootDir

Write-Output "$(Get-Date): Start download package"
$Package = Get-Content -Path "package-lock.json" | ConvertFrom-Json

$dependence=$Package.dependencies.VanessaAutomation
$PackageCatalog = "./.opm/VanessaAutomation"
$DownloadCatalog = "$PackageCatalog/download"
$Outfile = "$DownloadCatalog/vanessa-automation-single.zip"
Write-Output "$(Get-Date): Downloading Vanessa Automation from $($dependence.resolved) to $Outfile"

if (Test-Path -Path "$PackageCatalog") { Remove-Item -Recurse -Force "$PackageCatalog"}
New-Item -Force -ItemType "directory" "$DownloadCatalog" | Out-Null
Invoke-WebRequest -Uri "$($dependence.resolved)" -OutFile "$Outfile"

Write-Output "$(Get-Date): Unpack package to '$PackageCatalog'"
Expand-Archive "$Outfile" -DestinationPath "$PackageCatalog" -Force
ConvertTo-Json -InputObject $dependence | Out-File -FilePath "$PackageCatalog/version.json"

$stopwatch.Stop()
Write-Output "$(Get-Date): Complete download package in $([int] $stopwatch.Elapsed.TotalSeconds)"
popd