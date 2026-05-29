# POC Test for sessionStart.ps1 Copilot Hook
# Verifies normal and failure cases for durability and integrity enforcement


# Enhanced POC Test for sessionStart.ps1 Copilot Hook
# Covers normal, missing, empty, and corrupted state file cases, log checks, multiple runs, and summary

$testDir = "$PSScriptRoot/test-sessionStart-tmp"
$stateFile = "$testDir/state.json"
$integrityLog = "$testDir/integrity.log"
$results = @()

function Assert {
    param($Condition, $PassMsg, $FailMsg, $Output)
    if ($Condition) {
        Write-Host "[PASS] $PassMsg" -ForegroundColor Green
        $results += "PASS: $PassMsg"
    } else {
        Write-Host "[FAIL] $FailMsg" -ForegroundColor Red
        $results += "FAIL: $FailMsg"
        if ($Output) { Write-Host $Output }
    }
}

try {
    # Clean up and set up test directory
    if (Test-Path $testDir) { Remove-Item $testDir -Recurse -Force }
    New-Item -ItemType Directory -Path $testDir | Out-Null

    # --- Normal Case ---
    Set-Content -Path $stateFile -Value '{"foo": "bar"}'
    Write-Host "[TEST] Running sessionStart.ps1 (normal case)"
    $normal = & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/sessionStart.ps1" -StateFile $stateFile -IntegrityLog $integrityLog 2>&1
    $exitCode = $LASTEXITCODE
    $logExists = Test-Path $integrityLog
    $logHasHash = $logExists -and (Select-String -Path $integrityLog -Pattern 'SHA256=' -Quiet)
    Assert ($exitCode -eq 0 -and $logHasHash -and ($normal -match 'Durability and integrity checks complete')) `
        "Normal case: Hook succeeded, hash logged, output as expected." `
        "Normal case: Hook failed, hash not logged, or output missing." $normal

    # --- Multiple Runs (append log) ---
    Write-Host "[TEST] Running sessionStart.ps1 (second run, log append)"
    $normal2 = & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/sessionStart.ps1" -StateFile $stateFile -IntegrityLog $integrityLog 2>&1
    $lines = Get-Content $integrityLog
    Assert ($lines.Count -ge 2) `
        "Multiple runs: Log file appends new entry." `
        "Multiple runs: Log file did not append."

    # --- Edge Case: Empty State File ---
    Set-Content -Path $stateFile -Value ''
    Write-Host "[TEST] Running sessionStart.ps1 (empty state file)"
    $empty = & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/sessionStart.ps1" -StateFile $stateFile -IntegrityLog $integrityLog 2>&1
    $exitCode = $LASTEXITCODE
    Assert ($exitCode -eq 0 -and ($empty -match 'Durability and integrity checks complete')) `
        "Empty state file: Hook succeeded and output as expected." `
        "Empty state file: Hook failed or output missing." $empty

    # --- Failure Case: Missing state file ---
    Remove-Item $stateFile
    Write-Host "[TEST] Running sessionStart.ps1 (missing state file)"
    $fail = & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/sessionStart.ps1" -StateFile $stateFile -IntegrityLog $integrityLog 2>&1
    $exitCode = $LASTEXITCODE
    Assert ($exitCode -ne 0 -and ($fail -match 'does not exist')) `
        "Failure case: Properly failed on missing state file." `
        "Failure case: Did not fail as expected." $fail

    # --- Edge Case: Corrupted State File (locked) ---
    Set-Content -Path $stateFile -Value '{"foo": "bar"}'
    $stream = [System.IO.File]::Open($stateFile, 'Open', 'Read', 'None')
    try {
        Write-Host "[TEST] Running sessionStart.ps1 (corrupted/locked state file)"
        $corrupt = & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/sessionStart.ps1" -StateFile $stateFile -IntegrityLog $integrityLog 2>&1
        $exitCode = $LASTEXITCODE
        Assert ($exitCode -ne 0 -and ($corrupt -match 'Failed to read state file')) `
            "Corrupted/locked state file: Properly failed to read." `
            "Corrupted/locked state file: Did not fail as expected." $corrupt
    } finally {
        $stream.Close()
    }

    # --- Log File Creation Check ---
    Assert (Test-Path $integrityLog) `
        "Log file: integrity.log was created." `
        "Log file: integrity.log was not created."

} finally {
    # Robust cleanup
    try { if (Test-Path $testDir) { Remove-Item $testDir -Recurse -Force } } catch { Write-Warning "Cleanup failed: $_" }
}

# --- Summary ---
Write-Host "\n==== Test Summary ====" -ForegroundColor Cyan
$results | ForEach-Object { Write-Host $_ }
