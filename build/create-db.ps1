. $PSScriptRoot\before_script.ps1

function StartJobs([Hashtable[]] $JobsInfo)
{
    $BackgroundJobs = New-Object object[] ($JobsInfo.count)
    $JobsCounter = 0
    foreach ($JobInfo in $JobsInfo) {
        $BackgroundJobs[$JobsCounter] = Start-Job -Name $JobInfo.Name -ArgumentList $JobInfo.Arguments -ScriptBlock $JobInfo.Script
        $JobsCounter += 1
    }
    return $BackgroundJobs
}
function ControlJobs([object[]] $BackgroundJobs,  [int]$JobsTimeout)
{
    $BackgroundJobs = Wait-Job -Job $BackgroundJobs -Timeout $JobsTimeout
    
    $HasError = $false
    foreach ($jobElement in $BackgroundJobs) {
        Receive-Job -Job $jobElement | Write-Host
        if ($jobElement.State -eq "Failed") {
            $HasError = $true
            Write-Error "Job $($jobElement.Name) is fail"
        }elseif ($jobElement.State -eq "Running") {
            Write-Error "Job $($jobElement.Name) completion timeout exceeded"
            Stop-Job -Job $jobElement
            $HasError = $true
        }
    } 
    return $HasError
}

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$RootDir="$PSScriptRoot\.."
pushd $RootDir

Write-Output "$(Get-Date): Start create DB"
$SettingsObject = Get-Content -Path "settings.json" | ConvertFrom-Json

.\build\convert-cfg.ps1
$JobsInfo = @()
$JobsInfo += @{ Name = "ImportCfgJob"; Arguments = @("$RootDir");  Script = {cd "$($args[0])" ; .\build\import-cfg.ps1}}
#$JobsInfo += @{ Name = "ImportCfgJob"; Arguments = @("$RootDir");  Script = {cd "$($args[0])" ; .\build\convert-cfg.ps1}}
$ExtCounter = 1
foreach ($extension in $SettingsObject.Build.Extensions) {
     $JobsInfo += @{ Name = "ConvertExt${ExtCounter}Job"; Arguments = @("$RootDir",$extension);  Script = {cd "$($args[0])" ; .\build\convert-ext.ps1 $args[1]} }
     $ExtCounter += 1
}

$BackgroundJobs = StartJobs $JobsInfo
$HasError = ControlJobs $BackgroundJobs $SettingsObject.JobsTimeout
Remove-Job -Job $BackgroundJobs
if ($HasError) {
    throw "Can't create DB"
}

#.\build\import-cfg.ps1
foreach ($extension in $SettingsObject.Build.Extensions) {
    .\build\import-ext.ps1 $extension
}

# TODO: ограничить время и ловить результат через /DumpResult
$_1CE_TargetDB = "$RootDir\.db"
Write-Output "$(Get-Date): Start initialize information base '$_1CE_TargetDB'"
Exec1cv8 { 1cv8.exe ENTERPRISE /WA- /DisableStartupDialogs /F "$_1CE_TargetDB" /C ВыполнитьОбновлениеИЗавершитьРаботу }
Write-Output "$(Get-Date): Finish initialize information base"

$stopwatch.Stop()
Write-Output "$(Get-Date): Finish create DB successfully in $([int] $stopwatch.Elapsed.TotalSeconds)"