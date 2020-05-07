.\build\set-globals.ps1

if (-not (Test-Path env:EDT_ProjectDir_Configuration)) {
  Write-Error "Set EDT_ProjectDir_Configuration !"
}

$projectDir = "$ROOT_DIR\$env:EDT_ProjectDir_Configuration"

if (Test-Path env:Extension1) {
  $extension1Dir = "$ROOT_DIR\$env:EDT_ProjectDir_Extension1"
}

if (Test-Path env:Extension2) {
  $extension2Dir = "$ROOT_DIR\$env:EDT_ProjectDir_Extension2"
}

if (Test-Path env:Extension3) {
  $extension3Dir = "$ROOT_DIR\$env:EDT_ProjectDir_Extension3"
}

if (-not (Test-Path env:EDT_ValidationResult)) {
  $env:EDT_ValidationResult = "$ROOT_DIR\validation.tsv"
}

$EDT_ValidationResult = $env:EDT_ValidationResult

if (Test-Path $EDT_ValidationResult) {
  Remove-Item -Path $EDT_ValidationResult -Recurse
}

.\3dparty\ring.ps1 validate --project-list $projectDir $extension1Dir $extension2Dir $extension3Dir --file $env:EDT_ValidationResult

.\build\tools\cat-error-log.ps1 $env:EDT_ValidationResult ".\build\config\exclude-validate" UTF8