if (-not $StateFile -or -not $IntegrityLog -or -not $RecoveryLog) {
    Write-Error "[FATAL] Required parameter missing: StateFile, IntegrityLog, or RecoveryLog is empty."
    exit 99
}



function Independent-Process-Readback($filePath, $IntegrityLog) {
    $readbackScript = @"
    $file = '$filePath'
    $lines = Get-Content $file
    $last = $lines[-1]
    $ok = $false
    try {
        $obj = $last | ConvertFrom-Json
        $ok = $true
    } catch {}
    $result = @{ timestamp = (Get-Date -Format o); event = 'independentReadback'; file = $file; success = $ok }
    Add-Content -Path '$IntegrityLog' -Value ($result | ConvertTo-Json -Compress)
"@
    $tmp = [System.IO.Path]::GetTempFileName() + '.ps1'
    Set-Content -Path $tmp -Value $readbackScript
    powershell -NoProfile -ExecutionPolicy Bypass -File $tmp
    Remove-Item $tmp -Force
}
function Backup-And-Attest($filePath, $IntegrityLog) {
    $timestamp = Get-Date -Format 'yyyyMMddTHHmmssfff'
    $parentDir = (Split-Path $filePath -Parent)
    if (-not $parentDir) { $parentDir = '.' }
    $backupDir = Join-Path $parentDir 'backups'
    $backupDir = [System.IO.Path]::GetFullPath($backupDir)
    if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir | Out-Null }
    $backupFile = Join-Path $backupDir ("$(Split-Path $filePath -Leaf).$timestamp.bak")
    Copy-Item $filePath $backupFile -Force
    $origHash = (Get-FileHash $filePath -Algorithm SHA256).Hash.ToLower()
    $bakHash = (Get-FileHash $backupFile -Algorithm SHA256).Hash.ToLower()
    $attest = @{ timestamp = (Get-Date -Format o); event = "backupAttestation"; source = $filePath; backup = $backupFile; origHash = $origHash; bakHash = $bakHash; verified = ($origHash -eq $bakHash) }
    Add-Content -Path $IntegrityLog -Value ($attest | ConvertTo-Json -Compress)
    try {
        $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
        $fs.Flush($true)
        $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
    if (-not ($origHash -eq $bakHash)) { Write-Warning "[backupAttestation] Hash mismatch for $filePath → $backupFile" }
}
# Copilot Hook: errorOccurred
# Purpose: Trigger recovery and log integrity state on error
# Reference: Copilot lifecycle mapping, threat pattern catalog




if ($Help) {
    Write-Host "errorOccurred.ps1 - Copilot Hook for Error/Recovery Logging"
    Write-Host "Parameters:"
    Write-Host "  -StateFile <path>      Path to state file (default: state.json)"
    Write-Host "  -IntegrityLog <path>   Path to integrity log (default: integrity.log)"
    Write-Host "  -RecoveryLog <path>    Path to recovery log (default: recovery.log)"
    Write-Host "  -HashAlgorithm <alg>   Hash algorithm (default: SHA256)"
    Write-Host "  -ErrorContext <str>    Error context/message (optional)"
    Write-Host "  -Verbose               Verbose output"
    Write-Host "  -Help                  Show this help message"
    exit 0
}

function New-ErrorId {
    return ([guid]::NewGuid().ToString())
}

if ($Verbose) { Write-Host "[errorOccurred] Hook triggered. Logging integrity state and initiating recovery..." -ForegroundColor Red }

# Parameter validation
if (-not $StateFile -or -not $IntegrityLog -or -not $RecoveryLog) {
    Write-Error "StateFile, IntegrityLog, and RecoveryLog parameters are required."
    exit 2
}

$errorId = New-ErrorId
$now = Get-Date -Format o

# Log current integrity state as JSON
if (Test-Path $StateFile) {
    try {
        $hash = [System.BitConverter]::ToString((Get-FileHash $StateFile -Algorithm $HashAlgorithm).Hash).Replace("-", "").ToLower()
        $logEntry = @{ timestamp = $now; event = "errorOccurred"; file = $StateFile; hashAlgorithm = $HashAlgorithm; hash = $hash; errorId = $errorId }
        Add-Content -Path $IntegrityLog -Value ($logEntry | ConvertTo-Json -Compress)
        Backup-And-Attest $IntegrityLog $IntegrityLog
        Independent-Process-Readback $IntegrityLog $IntegrityLog
        try {
            $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
            $fs.Flush($true)
            $fs.Close()
        } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
    } catch {
        $logEntry = @{ timestamp = $now; event = "errorOccurred"; file = $StateFile; error = "Hashing failed: $_"; errorId = $errorId }
        Add-Content -Path $IntegrityLog -Value ($logEntry | ConvertTo-Json -Compress)
        Backup-And-Attest $IntegrityLog $IntegrityLog
        Independent-Process-Readback $IntegrityLog $IntegrityLog
        try {
            $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
            $fs.Flush($true)
            $fs.Close()
        } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
    }
} else {
    $logEntry = @{ timestamp = $now; event = "errorOccurred"; file = $StateFile; error = "MISSING"; errorId = $errorId }
    Add-Content -Path $IntegrityLog -Value ($logEntry | ConvertTo-Json -Compress)
    Backup-And-Attest $IntegrityLog $IntegrityLog
    Independent-Process-Readback $IntegrityLog $IntegrityLog
    try {
        $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
        $fs.Flush($true)
        $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
}

# Recovery: Log recovery action as JSON
$recoveryEntry = @{ timestamp = $now; event = "errorOccurred"; file = $StateFile; action = "Recovery initiated"; errorId = $errorId }
if ($ErrorContext) { $recoveryEntry.errorContext = $ErrorContext }
Add-Content -Path $RecoveryLog -Value ($recoveryEntry | ConvertTo-Json -Compress)
Backup-And-Attest $RecoveryLog $IntegrityLog
Independent-Process-Readback $RecoveryLog $IntegrityLog
try {
    $fs = [System.IO.File]::Open($RecoveryLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
    $fs.Flush($true)
    $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush ${RecoveryLog}: $_" }

if ($Verbose) { Write-Host "[errorOccurred] Integrity state logged and recovery action recorded. ErrorId: $errorId" -ForegroundColor Yellow }
else { Write-Host "[errorOccurred] Complete. ErrorId: $errorId" -ForegroundColor Yellow }
exit 0


