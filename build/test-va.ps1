. $PSScriptRoot\before_script.ps1

$stopwatch =  [system.diagnostics.stopwatch]::StartNew()
$RootDir="$PSScriptRoot\.."
pushd $RootDir

.\build\download-va.ps1

$SettingsObject = Get-Content -Path "settings.json" | ConvertFrom-Json
Write-Output "$(Get-Date): Start run unit tests"

$UnitTestExtension = $SettingsObject.UnitTests.Extension
.\build\convert-ext.ps1 $UnitTestExtension
.\build\import-ext.ps1 $UnitTestExtension

$ExtensionName = $UnitTestExtension
$EDT_ProjectPath = ""
foreach ($extension in $SettingsObject.Extensions) {
    if ($extension.name -eq $ExtensionName) {
        $EDT_ProjectPath = $extension.EDT_ProjectDir
        break
    }
}

$_1CE_TargetDB = "$RootDir/.db"
$UsingTestConfig=$SettingsObject.UnitTests.Config
New-Item -Force -ItemType "directory" ".test/unit" | Out-Null
$RootDir=$RootDir -replace "\\", "/"

Write-Output "$(Get-Date): Running test on DB '$_1CE_TargetDB' with config at '$RootDir/$UsingTestConfig'"

$Env:VANESSA_featurepath = "$EDT_ProjectPath\features\"
Exec1cv8 { 1cv8.exe ENTERPRISE /WA- /DisableStartupDialogs /F "$_1CE_TargetDB" /Execute .\.opm\VanessaAutomation\vanessa-automation-single.epf /C "StartFeaturePlayer;workspaceRoot=$RootDir;VBParams=$RootDir\$UsingTestConfig" }

$stopwatch.Stop()
Write-Output "$(Get-Date): Finish run unit tests in $([int] $stopwatch.Elapsed.TotalSeconds)"

$filelog='.test/unit/exitCode.txt'
if(Test-Path -Path $filelog)
  { if(Select-String -Path $filelog -Pattern "^0$" -Quiet) {exit 0} 
	elseif (Select-String -Path $filelog -Pattern "^1$" -Quiet) {echo "Unit tests failed! View the results in 'junit/'."; exit 1} 
	else {echo "In unit tests log file '$filelog' unexpected code."; exit 1} } 
  else {echo "File '$filelog' with unit tests results is absent!"; exit 1};
