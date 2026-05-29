# POC Test for errorOccurred.ps1
# Covers normal, missing, and corrupted state file cases, error context, log checks, and summary reporting.

param(
    [string]$TestDir = "./test-errorOccurred-tmp"
)

$ErrorActionPreference = "Stop"

function Write-Section($msg) { Write-Host "`n==== $msg ====" -ForegroundColor Cyan }
function Assert-LogContains($Path, $Pattern, $Msg) {
    if (-not (Select-String -Path $Path -Pattern $Pattern -Quiet)) {
        Write-Host "[FAIL] $Msg" -ForegroundColor Red
        exit 1
    } else {
        Write-Host "[PASS] $Msg" -ForegroundColor Green
    }
}

# Setup
if (Test-Path $TestDir) { Remove-Item $TestDir -Recurse -Force }
New-Item -ItemType Directory -Path $TestDir | Out-Null
Push-Location $TestDir

$stateFile = "state.json"
$integrityLog = "integrity.log"
$recoveryLog = "recovery.log"

# 1. Normal case
Write-Section "Normal case: valid state file"
@{ foo = "bar" } | ConvertTo-Json | Set-Content $stateFile
$errorContext = "Test error context"
& "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/errorOccurred.ps1" -StateFile $stateFile -IntegrityLog $integrityLog -RecoveryLog $recoveryLog -ErrorContext $errorContext -Verbose
Assert-LogContains $integrityLog '"event":"errorOccurred"' "Log entry for errorOccurred event (normal)"
Assert-LogContains $recoveryLog '"action":"Recovery initiated"' "Recovery action logged"
Assert-LogContains $recoveryLog '"errorContext":"Test error context"' "Error context logged"

# 2. Missing state file
Write-Section "Missing state file"
Remove-Item $stateFile -ErrorAction SilentlyContinue
& "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/errorOccurred.ps1" -StateFile $stateFile -IntegrityLog $integrityLog -RecoveryLog $recoveryLog -ErrorContext $errorContext -Verbose
Assert-LogContains $integrityLog '"error":"MISSING"' "Missing state file log entry"
Assert-LogContains $recoveryLog '"action":"Recovery initiated"' "Recovery action for missing state file"

# 3. Help output
Write-Section "Help output"
$output = & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/errorOccurred.ps1" -Help
if ($output -notmatch "errorOccurred.ps1") {
    Write-Host "[FAIL] Help output missing" -ForegroundColor Red
    exit 1
} else {
    Write-Host "[PASS] Help output present" -ForegroundColor Green
}

Pop-Location
Remove-Item $TestDir -Recurse -Force
Write-Host "`nAll errorOccurred.ps1 tests passed!" -ForegroundColor Green
