if ($Env:system_debug -eq "true") 
    { Set-PSDebug -Trace 1 }
else 
    { Set-PSDebug -Trace 0 }
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
#$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
#chcp 65001 | Out-Null

function ExecSafe($Command)
{
    Invoke-Command -ScriptBlock $Command
    if ($LastExitCode -ne 0) { 
        $CommandExitCode = $LastExitCode
        $StrCommand = $Command.toString()
        $StrCommand = $ExecutionContext.InvokeCommand.ExpandString($StrCommand)
        throw "Command '$StrCommand' exit with error $CommandExitCode" 
    }
}

function Exec1cv8($Command)
{
    $StrCommand = $Command.toString()
    $LogFile=".build/1cv8.log"
    $StrCommand = "$StrCommand /L en /Out $LogFile | Out-Default"
    
    New-Item -Force -ItemType "directory" ".build" | Out-Null
    try{
        ExecSafe($([scriptblock]::Create($StrCommand)))
    } finally {
        if (Test-Path -Path "$LogFile") { 
            Get-Content $LogFile | Write-Host
        }
    }
}
