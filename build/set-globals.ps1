if ($env:system_debug -eq "true") {
  $global:DebugPreference = "Continue"
} else {
  $global:DebugPreference = "SilentlyContinue"
}

$global:ErrorActionPreference = "Stop"

$global:ROOT_DIR = Join-Path -Path $PSScriptRoot -ChildPath .. -Resolve