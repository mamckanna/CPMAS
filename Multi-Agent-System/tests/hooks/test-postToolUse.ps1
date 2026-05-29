# POC Test for postToolUse.ps1
# Covers normal, missing, empty, and corrupted state/attestation file cases, log checks, and summary reporting.

param(
    [string]$TestDir = "./test-postToolUse-tmp"
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


# Setup (robust, with error handling)
if (Test-Path $TestDir) {
    try {
        Remove-Item $TestDir -Recurse -Force -ErrorAction Stop
    } catch {
        Write-Host "[WARN] Failed to clean up $TestDir - $($_)" -ForegroundColor Yellow
    }
}
New-Item -ItemType Directory -Path $TestDir -ErrorAction Stop | Out-Null
Push-Location $TestDir

$stateFile = "state.json"
$integrityLog = "integrity.log"
$attestationFile = "attestation.json"


# 1. Normal case
Write-Section "Normal case: valid state and attestation (verified)"
@{ foo = "bar" } | ConvertTo-Json | Set-Content $stateFile -ErrorAction Stop
@{ status = "verified"; agent = "copilot" } | ConvertTo-Json | Set-Content $attestationFile -ErrorAction Stop

$err = $null
& "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/postToolUse.ps1" -StateFile $stateFile -IntegrityLog $integrityLog -AttestationFile $attestationFile -Verbose -ErrorAction Stop -ErrorVariable err
if ($LASTEXITCODE -ne 0 -or $err) {
    Write-Host "[FAIL] postToolUse.ps1 failed in normal case. Error: $err, Exit: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "[DEBUG] Error: $($Error | Out-String)"
    exit 1
}
Assert-LogContains $integrityLog '"event":"postToolUse"' "Log entry for postToolUse event (normal)"
Assert-LogContains $integrityLog '"status":"verified"' "Attestation verified logged"


# 2. Attestation not verified
Write-Section "Attestation not verified"
@{ status = "unverified"; agent = "copilot" } | ConvertTo-Json | Set-Content $attestationFile -ErrorAction Stop
$err = $null
& "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/postToolUse.ps1" -StateFile $stateFile -IntegrityLog $integrityLog -AttestationFile $attestationFile -Verbose -ErrorAction Stop -ErrorVariable err
if ($LASTEXITCODE -ne 0 -or $err) {
    Write-Host "[FAIL] postToolUse.ps1 failed in attestation not verified. Error: $err, Exit: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "[DEBUG] Error: $($Error | Out-String)"
    exit 1
}
Assert-LogContains $integrityLog '"status":"unverified"' "Attestation unverified logged"


# 3. Missing attestation file
Write-Section "Missing attestation file"
if (Test-Path $attestationFile) { Remove-Item $attestationFile -ErrorAction Stop }
$err = $null
& "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/postToolUse.ps1" -StateFile $stateFile -IntegrityLog $integrityLog -AttestationFile $attestationFile -Verbose -ErrorAction Stop -ErrorVariable err
if ($LASTEXITCODE -ne 0 -or $err) {
    Write-Host "[FAIL] postToolUse.ps1 failed in missing attestation file. Error: $err, Exit: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "[DEBUG] Error: $($Error | Out-String)"
    exit 1
}
Assert-LogContains $integrityLog 'No attestation file found' "No attestation file log entry"


# 4. Corrupted attestation file
Write-Section "Corrupted attestation file"
"not-json" | Set-Content $attestationFile -ErrorAction Stop
$err = $null
& "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/postToolUse.ps1" -StateFile $stateFile -IntegrityLog $integrityLog -AttestationFile $attestationFile -Verbose -ErrorAction Stop -ErrorVariable err
if ($LASTEXITCODE -ne 0 -or $err) {
    Write-Host "[FAIL] postToolUse.ps1 failed in corrupted attestation file. Error: $err, Exit: $LASTEXITCODE" -ForegroundColor Red
    Write-Host "[DEBUG] Error: $($Error | Out-String)"
    exit 1
}
Assert-LogContains $integrityLog 'Failed to parse attestation file' "Corrupted attestation file log entry"


# 5. Missing state file
Write-Section "Missing state file"
if (Test-Path $stateFile) { Remove-Item $stateFile -ErrorAction Stop }
$err = $null
$null = & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/postToolUse.ps1" -StateFile $stateFile -IntegrityLog $integrityLog -AttestationFile $attestationFile -Verbose -ErrorAction SilentlyContinue -ErrorVariable err
$exitCode = $LASTEXITCODE
if ($exitCode -ne 1) {
    Write-Host "[FAIL] Missing state file should exit 1 (got $exitCode)" -ForegroundColor Red
    Write-Host "[DEBUG] Error: $($Error | Out-String)"
    exit 1
} else {
    Write-Host "[PASS] Missing state file exits 1" -ForegroundColor Green
}
Assert-LogContains $integrityLog 'State file does not exist' "Missing state file log entry"


# 6. Help output
Write-Section "Help output"
$output = & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/postToolUse.ps1" -Help -ErrorAction Stop
if ($output -notmatch "postToolUse.ps1") {
    Write-Host "[FAIL] Help output missing" -ForegroundColor Red
    Write-Host "[DEBUG] Error: $($Error | Out-String)"
    exit 1
} else {
    Write-Host "[PASS] Help output present" -ForegroundColor Green
}

# Robust cleanup
Pop-Location
try {
    Remove-Item $TestDir -Recurse -Force -ErrorAction Stop
} catch {
    Write-Host "[WARN] Failed to clean up $TestDir - $($_)" -ForegroundColor Yellow
}
Write-Host "`nAll postToolUse.ps1 tests passed!" -ForegroundColor Green
