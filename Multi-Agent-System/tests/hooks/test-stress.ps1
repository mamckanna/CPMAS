# Stress Test for Copilot PowerShell Hooks
# Simulates rapid, repeated, and concurrent invocations with large files and resource exhaustion

$testDir = "$PSScriptRoot/test-stress-tmp"
$stateFile = "$testDir/state.json"
$integrityLog = "$testDir/integrity.log"
$attestationFile = "$testDir/attestation.json"
$recoveryLog = "$testDir/recovery.log"

if (Test-Path $testDir) { Remove-Item $testDir -Recurse -Force }
New-Item -ItemType Directory -Path $testDir | Out-Null

# Large file test
$largeContent = 'A' * 10MB
Set-Content -Path $stateFile -Value $largeContent
@{ status = "verified" } | ConvertTo-Json | Set-Content $attestationFile

Write-Host "[STRESS] Large file: sessionStart.ps1"
& "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/sessionStart.ps1" -StateFile $stateFile -IntegrityLog $integrityLog

Write-Host "[STRESS] Large file: postToolUse.ps1"
& "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/postToolUse.ps1" -StateFile $stateFile -IntegrityLog $integrityLog -AttestationFile $attestationFile

# Rapid-fire loop
Write-Host "[STRESS] Rapid-fire: 20 runs of sessionStart.ps1"
for ($i = 0; $i -lt 20; $i++) {
    & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/sessionStart.ps1" -StateFile $stateFile -IntegrityLog $integrityLog
}

# Simulate disk full (if possible)
try {
    $drive = (Get-Item $testDir).PSDrive.Root
    $free = (Get-PSDrive | Where-Object { $_.Root -eq $drive }).Free
    if ($free -lt 20MB) {
        Write-Host "[STRESS] Disk nearly full, skipping disk full test."
    } else {
        Write-Host "[STRESS] Simulating disk full by filling disk (skipped for safety)"
        # To actually fill disk, create a huge file: Set-Content -Path "$testDir/fill.tmp" -Value ('X' * $free)
        # Skipped for safety.
    }
} catch { Write-Warning "Disk full simulation failed: $_" }

# Permission denied
try {
    $lockedFile = "$testDir/locked.json"
    Set-Content -Path $lockedFile -Value 'locked'
    $acl = Get-Acl $lockedFile
    $deny = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "Deny")
    $acl.AddAccessRule($deny)
    Set-Acl $lockedFile $acl
    Write-Host "[STRESS] Permission denied: sessionStart.ps1"
    & "$PSScriptRoot/../../Libraries/tools/multi-agent-system/hooks/sessionStart.ps1" -StateFile $lockedFile -IntegrityLog $integrityLog
    # Restore permissions
    Remove-Item $lockedFile -Force
} catch { Write-Warning "Permission denied simulation failed: $_" }

Remove-Item $testDir -Recurse -Force
Write-Host "[STRESS] All stress tests completed!" -ForegroundColor Green
