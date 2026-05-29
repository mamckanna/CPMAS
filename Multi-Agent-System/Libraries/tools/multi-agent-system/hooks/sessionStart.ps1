
param(
    [string]$StateFile = "state.json",
    [string]$IntegrityLog = "integrity.log",
    [string]$HashAlgorithm = "SHA256",
    [switch]$Verbose,
    [switch]$Help
)

# All function definitions at the top
function Independent-Process-Readback($filePath, $IntegrityLog) {
    $readbackScript = @"
$file = '$filePath'
$ok = $false
if ($file -and (Test-Path $file)) {
    $lines = Get-Content $file
    if ($lines.Count -gt 0) {
        $last = $lines[-1]
        try {
            $obj = $last | ConvertFrom-Json
            $ok = $true
        } catch {}
    }
}
$result = @{ timestamp = (Get-Date -Format o); event = 'independentReadback'; file = $file; success = $ok }
Add-Content -Path '$IntegrityLog' -Value ($result | ConvertTo-Json -Compress)
"@
    $tmp = [System.IO.Path]::GetTempFileName() + '.ps1'
    Set-Content -Path $tmp -Value $readbackScript
    powershell -NoProfile -ExecutionPolicy Bypass -File $tmp
    Remove-Item $tmp -Force
}

function Show-OperatorSummary($integrityLog) {
    if (Test-Path $integrityLog) {
        $lines = Get-Content $integrityLog | Select-Object -Last 10
        Write-Host "\n==== Operator Summary (Last 10 Events) ====" -ForegroundColor Cyan
        foreach ($line in $lines) {
            try {
                $obj = $line | ConvertFrom-Json
                $event = $obj.event
                $ts = $obj.timestamp
                $status = if ($obj.error -or $obj.warning -or ($obj.verified -eq $false)) { 'WARN' } else { 'OK' }
                $color = if ($status -eq 'OK') { 'Green' } else { 'Yellow' }
                Write-Host ("[${ts}] ${event}: ${status}") -ForegroundColor ${color}
            } catch {
                Write-Host $line -ForegroundColor Red
            }
        }
    }
}

function Resume-From-SessionHandoff($integrityLog) {
    $handoffDir = "memories/handoff"
    if (Test-Path $handoffDir) {
        $files = Get-ChildItem $handoffDir -Filter 'session-handoff-*.json' | Sort-Object LastWriteTime -Descending
        if ($files.Count -gt 0) {
            $latest = $files[0].FullName
            $handoff = Get-Content $latest | ConvertFrom-Json
            Write-Host "[sessionResume] Resuming from $latest" -ForegroundColor Cyan
            Write-Host "  Last state file: $($handoff.stateFile)"
            Write-Host "  Integrity log: $($handoff.integrityLog)"
            Write-Host "  Next actions: $($handoff.nextActions)"
            $log = @{ timestamp = (Get-Date -Format o); event = "sessionResume"; handoffFile = $latest; operator = $env:USERNAME; sessionId = [guid]::NewGuid().ToString() }
            Add-Content -Path $integrityLog -Value ($log | ConvertTo-Json -Compress)
            try {
                $fs = [System.IO.File]::Open($integrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
                $fs.Flush($true)
                $fs.Close()
            } catch { Write-Warning "[fsync] Failed to flush ${integrityLog}: $_" }
        }
    }
}

function Write-SessionHandoff($stateFile, $integrityLog) {
    $handoffDir = "memories/handoff"
    if (-not (Test-Path $handoffDir)) { New-Item -ItemType Directory -Path $handoffDir | Out-Null }
    $timestamp = Get-Date -Format 'yyyyMMddTHHmmss'
    $handoffFile = Join-Path $handoffDir ("session-handoff-$timestamp.json")
    $handoff = @{
        timestamp = (Get-Date -Format o)
        stateFile = $stateFile
        integrityLog = $integrityLog
        nextActions = "See integrity log and operator menu for next steps."
    }
    $handoff | ConvertTo-Json | Set-Content -Path $handoffFile
    $log = @{ timestamp = (Get-Date -Format o); event = "sessionHandoffWritten"; handoffFile = $handoffFile; operator = $env:USERNAME; sessionId = [guid]::NewGuid().ToString() }
    Add-Content -Path $integrityLog -Value ($log | ConvertTo-Json -Compress)
    try {
        $fs = [System.IO.File]::Open($integrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
        $fs.Flush($true)
        $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush ${integrityLog}: $_" }
}

function Backup-And-Attest($filePath, $integrityLog) {
    $timestamp = Get-Date -Format 'yyyyMMddTHHmmssfff'
    $parentDir = (Split-Path $filePath -Parent)
    if (-not $parentDir) { $parentDir = '.' }
    $backupDir = Join-Path $parentDir 'backups'
    if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir | Out-Null }
    $backupFile = Join-Path $backupDir ("$(Split-Path $filePath -Leaf).$timestamp.bak")
    Copy-Item $filePath $backupFile -Force
    $origHash = (Get-FileHash $filePath -Algorithm SHA256).Hash.ToLower()
    $bakHash = (Get-FileHash $backupFile -Algorithm SHA256).Hash.ToLower()
    $attest = @{ timestamp = (Get-Date -Format o); event = "backupAttestation"; source = $filePath; backup = $backupFile; origHash = $origHash; bakHash = $bakHash; verified = ($origHash -eq $bakHash) }
    Add-Content -Path $integrityLog -Value ($attest | ConvertTo-Json -Compress)
    try {
        $fs = [System.IO.File]::Open($integrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
        $fs.Flush($true)
        $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush ${integrityLog}: $_" }
    if (-not ($origHash -eq $bakHash)) { Write-Warning "[backupAttestation] Hash mismatch for $filePath → $backupFile" }
}

# Copilot Hook: sessionStart
# Purpose: Enforce durability and integrity checks at the start of a session
# Reference: Copilot lifecycle mapping, threat pattern catalog

# Utility: Write a log entry, backup, fsync, and readback in one call
function Write-LogEntry {
    param(
        [Parameter(Mandatory)]$LogObject,
        [Parameter(Mandatory)]$LogPath
    )
    Add-Content -Path $LogPath -Value ($LogObject | ConvertTo-Json -Compress)
    Backup-And-Attest $LogPath $LogPath
    Independent-Process-Readback $LogPath $LogPath
    try {
        $fs = [System.IO.File]::Open($LogPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
        $fs.Flush($true)
        $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush ${LogPath}: $_" }
}




if ($Help) {
    Write-Host "sessionStart.ps1 - Copilot Hook for Durability/Integrity Enforcement"
    Write-Host "Parameters:"
    Write-Host "  -StateFile <path>      Path to state file (default: state.json)"
    Write-Host "  -IntegrityLog <path>   Path to integrity log (default: integrity.log)"
    Write-Host "  -HashAlgorithm <alg>   Hash algorithm (default: SHA256)"
    Write-Host "  -Verbose               Verbose output"
    Write-Host "  -Help                  Show this help message"
    exit 0
}

if ($Verbose) { Write-Host "[sessionStart] Hook triggered. Starting durability and integrity checks..." -ForegroundColor Cyan }
Resume-From-SessionHandoff $IntegrityLog
Show-OperatorSummary $IntegrityLog

# Parameter validation
if (-not $StateFile -or -not $IntegrityLog) {
    Write-Error "StateFile and IntegrityLog parameters are required."
    exit 2
}

# Durability: Ensure state file exists and is readable
if (-Not (Test-Path $StateFile)) {
    $err = @{ timestamp = (Get-Date -Format o); event = "sessionStart"; file = $StateFile; error = "State file does not exist" }
    Write-LogEntry -LogObject $err -LogPath $IntegrityLog
    Write-SessionHandoff $StateFile $IntegrityLog
    Write-Error "State file '$StateFile' does not exist."
    exit 1
}

# Check file size
$fileInfo = Get-Item $StateFile
if ($fileInfo.Length -eq 0) {
    $warn = @{ timestamp = (Get-Date -Format o); event = "sessionStart"; file = $StateFile; warning = "State file is empty" }
    Write-LogEntry -LogObject $warn -LogPath $IntegrityLog
    if ($Verbose) { Write-Warning "State file is empty." }
}

try {
    $content = Get-Content $StateFile -Raw
} catch {
    $err = @{ timestamp = (Get-Date -Format o); event = "sessionStart"; file = $StateFile; error = "Failed to read state file: $_" }
    Write-LogEntry -LogObject $err -LogPath $IntegrityLog
    Write-Error "Failed to read state file: $_"
    exit 3
}

# Integrity: Compute hash and log as JSON
try {
    $hash = [System.BitConverter]::ToString((Get-FileHash $StateFile -Algorithm $HashAlgorithm).Hash).Replace("-", "").ToLower()
    $logEntry = @{ timestamp = (Get-Date -Format o); event = "sessionStart"; file = $StateFile; hashAlgorithm = $HashAlgorithm; hash = $hash }
    Write-LogEntry -LogObject $logEntry -LogPath $IntegrityLog
    if ($Verbose) { Write-Host "[sessionStart] Durability and integrity checks complete. Hash: $hash" -ForegroundColor Green }
    else { Write-Host "[sessionStart] Complete." -ForegroundColor Green }
    exit 0
} catch {
    $err = @{ timestamp = (Get-Date -Format o); event = "sessionStart"; file = $StateFile; error = "Hashing/logging failed: $_" }
    Write-LogEntry -LogObject $err -LogPath $IntegrityLog
    Write-Error "Hashing/logging failed: $_"
    exit 4
}
