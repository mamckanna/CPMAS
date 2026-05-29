

function Independent-Process-Readback($filePath, $IntegrityLog) {
    # Always resolve absolute paths for subprocess
    $absFilePath = Resolve-Path $filePath | ForEach-Object { $_.Path }
    $absIntegrityLog = Resolve-Path $IntegrityLog | ForEach-Object { $_.Path }
    $readbackScript = @'
$file = $args[0]
$IntegrityLog = $args[1]
if ($null -eq $file) { $file = "" }
$ok = $false
$warning = $null
if (-not $file) {
    $warning = 'No file specified'
} elseif (-not (Test-Path $file)) {
    $warning = 'File does not exist'
} else {
    $lines = Get-Content $file
    if ($lines.Count -gt 0) {
        $last = $lines[-1]
        try {
            $obj = $last | ConvertFrom-Json
            $ok = $true
        } catch {
            $warning = "JSON parse error: $_"
        }
    } else {
        $warning = 'File is empty'
    }
}
    try {
        if (-not (Test-Path $IntegrityLog)) { New-Item -ItemType File -Path $IntegrityLog | Out-Null }
        $result = @{ timestamp = (Get-Date -Format o); event = 'independentReadback'; file = $file; success = $ok }
        if ($warning) { $result.warning = $warning }
        Add-Content -Path $IntegrityLog -Value ($result | ConvertTo-Json -Compress)
    } catch {
        Write-Warning "[independentReadback] Failed to write to $IntegrityLog - $($_)"
    }
'@
    $tmp = [System.IO.Path]::GetTempFileName() + '.ps1'
    Set-Content -Path $tmp -Value $readbackScript
    powershell -NoProfile -ExecutionPolicy Bypass -File $tmp $absFilePath $absIntegrityLog
    Remove-Item $tmp -Force
}
function Backup-And-Attest($filePath, $integrityLog, $HashAlgorithm) {
    if (-not $HashAlgorithm) {
        $HashAlgorithm = "SHA256"
    }

    $absFilePath = Resolve-Path $filePath | ForEach-Object { $_.Path }
    $absIntegrityLog = Resolve-Path $integrityLog | ForEach-Object { $_.Path }
    $timestamp = Get-Date -Format 'yyyyMMddTHHmmssfff'
    $parentDir = (Split-Path $absFilePath -Parent)
    if (-not $parentDir) { $parentDir = '.' }
    $backupDir = Join-Path $parentDir 'backups'
    if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir | Out-Null }
    $backupFile = Join-Path $backupDir ("$(Split-Path $absFilePath -Leaf).$timestamp.bak")
    if (Test-Path $absFilePath) {
        try {
            Copy-Item $absFilePath $backupFile -Force
            $origHash = (Get-FileHash $absFilePath -Algorithm $HashAlgorithm).Hash.ToLower()
            $bakHash = (Get-FileHash $backupFile -Algorithm $HashAlgorithm).Hash.ToLower()
        } catch {
            Write-Warning "[backupAttestation] Failed to copy or hash - $($_)"
            $origHash = $null
            $bakHash = $null
        }
    } else {
        $origHash = $null
        $bakHash = $null
    }
    try {
        if (-not (Test-Path $absIntegrityLog)) { New-Item -ItemType File -Path $absIntegrityLog | Out-Null }
        $attest = @{ timestamp = (Get-Date -Format o); event = "backupAttestation"; source = $absFilePath; backup = $backupFile; origHash = $origHash; bakHash = $bakHash; verified = ($origHash -eq $bakHash) }
        Add-Content -Path $absIntegrityLog -Value ($attest | ConvertTo-Json -Compress)
    } catch {
        Write-Warning "[backupAttestation] Failed to write to $absIntegrityLog - $($_)"
    }
    try {
        $fs = [System.IO.File]::Open($absIntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
        $fs.Flush($true)
        $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush $absIntegrityLog - $($_)" }
    if ($origHash -and $bakHash -and -not ($origHash -eq $bakHash)) { Write-Warning "[backupAttestation] Hash mismatch for $absFilePath → $backupFile" }
}
# Copilot Hook: postToolUse
# Purpose: Enforce integrity and truthfulness checks after tool use
# Reference: Copilot lifecycle mapping, threat pattern catalog




if (-not $HashAlgorithm) { $HashAlgorithm = "SHA256" }

if ($Help) {
    Write-Host "postToolUse.ps1 - Copilot Hook for Integrity/Truthfulness Enforcement"
    Write-Host "Parameters:"
    Write-Host "  -StateFile <path>        Path to state file (default: state.json)"
    Write-Host "  -IntegrityLog <path>     Path to integrity log (default: integrity.log)"
    Write-Host "  -AttestationFile <path>  Path to attestation file (default: attestation.json)"
    Write-Host "  -HashAlgorithm <alg>     Hash algorithm (default: SHA256)"
    Write-Host "  -Verbose                 Verbose output"
    Write-Host "  -Help                    Show this help message"
    exit 0
}

if ($Verbose) { Write-Host "[postToolUse] Hook triggered. Running integrity and truthfulness checks..." -ForegroundColor Cyan }


# Parameter validation
if (-not $StateFile -or -not $IntegrityLog) {
    Write-Error "StateFile and IntegrityLog parameters are required."
    exit 2
}
# Ensure log file exists before resolving path
if (-not (Test-Path $IntegrityLog)) {
    $logDir = Split-Path $IntegrityLog -Parent
    if ($logDir -and -not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir | Out-Null }
    New-Item -ItemType File -Path $IntegrityLog | Out-Null
}
# Robust absolute path resolution for all files
function Get-AbsolutePath($path) {
    if (Test-Path $path) {
        return (Resolve-Path $path | ForEach-Object { $_.Path })
    } else {
        $parent = Split-Path $path -Parent
        if ($parent -and (Test-Path $parent)) {
            return (Join-Path (Convert-Path $parent) (Split-Path $path -Leaf))
        } else {
            return $path
        }
    }
}
$StateFile = Get-AbsolutePath $StateFile
$IntegrityLog = Get-AbsolutePath $IntegrityLog
if ($AttestationFile) {
    $AttestationFile = Get-AbsolutePath $AttestationFile
}

# Integrity: Compute hash and log as JSON
if (-Not (Test-Path $StateFile)) {
    $err = @{ timestamp = (Get-Date -Format o); event = "postToolUse"; file = $StateFile; error = "State file does not exist" }
    Add-Content -Path $IntegrityLog -Value ($err | ConvertTo-Json -Compress)
    Backup-And-Attest $StateFile $IntegrityLog $HashAlgorithm
    Independent-Process-Readback $StateFile $IntegrityLog
    try {
        $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
        $fs.Flush($true)
        $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
    Write-Error "State file '$StateFile' does not exist."
    exit 1
}

try {
    $hashObj = Get-FileHash $StateFile -Algorithm $HashAlgorithm
    $hash = $hashObj.Hash.ToLower()
    $logEntry = @{ timestamp = (Get-Date -Format o); event = "postToolUse"; file = $StateFile; hashAlgorithm = $HashAlgorithm; hash = $hash }
    Add-Content -Path $IntegrityLog -Value ($logEntry | ConvertTo-Json -Compress)
    Backup-And-Attest $StateFile $IntegrityLog $HashAlgorithm
    Independent-Process-Readback $StateFile $IntegrityLog
    try {
        $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
        $fs.Flush($true)
        $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
} catch {
    $err = @{ timestamp = (Get-Date -Format o); event = "postToolUse"; file = $StateFile; error = "Hashing/logging failed: $_" }
    Add-Content -Path $IntegrityLog -Value ($err | ConvertTo-Json -Compress)
    Write-Error "Hashing/logging failed: $_"
    exit 3
}

# Truthfulness: Attestation check (if attestation file exists)
$attestationStatus = $null
if (Test-Path $AttestationFile) {
    try {
        $attestationRaw = Get-Content $AttestationFile -Raw
        $attestation = $attestationRaw | ConvertFrom-Json
        if ($null -eq $attestation.status) {
            $attnLog = @{ timestamp = (Get-Date -Format o); event = "postToolUse"; attestationFile = $AttestationFile; error = "Missing 'status' in attestation file" }
            Add-Content -Path $IntegrityLog -Value ($attnLog | ConvertTo-Json -Compress)
            Backup-And-Attest $AttestationFile $IntegrityLog $HashAlgorithm
            Independent-Process-Readback $AttestationFile $IntegrityLog
            try {
                $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
                $fs.Flush($true)
                $fs.Close()
            } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
            Write-Warning "Attestation file missing 'status' property."
        } elseif ($attestation.status -ne "verified") {
            $attnLog = @{ timestamp = (Get-Date -Format o); event = "postToolUse"; attestationFile = $AttestationFile; status = $attestation.status; warning = "Attestation not verified" }
            Add-Content -Path $IntegrityLog -Value ($attnLog | ConvertTo-Json -Compress)
            Backup-And-Attest $AttestationFile $IntegrityLog $HashAlgorithm
            Independent-Process-Readback $AttestationFile $IntegrityLog
            try {
                $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
                $fs.Flush($true)
                $fs.Close()
            } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
            Write-Warning "Attestation status is not verified: $($attestation.status)"
        } else {
            $attnLog = @{ timestamp = (Get-Date -Format o); event = "postToolUse"; attestationFile = $AttestationFile; status = $attestation.status }
            Add-Content -Path $IntegrityLog -Value ($attnLog | ConvertTo-Json -Compress)
            Backup-And-Attest $AttestationFile $IntegrityLog $HashAlgorithm
            Independent-Process-Readback $AttestationFile $IntegrityLog
            try {
                $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
                $fs.Flush($true)
                $fs.Close()
            } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
            if ($Verbose) { Write-Host "Attestation verified." -ForegroundColor Green }
        }
    } catch {
        $attnLog = @{ timestamp = (Get-Date -Format o); event = "postToolUse"; attestationFile = $AttestationFile; error = "Failed to parse attestation file: $_" }
        Add-Content -Path $IntegrityLog -Value ($attnLog | ConvertTo-Json -Compress)
        Write-Warning "Failed to parse attestation file: $_"
    }
} else {
    $attnLog = @{ timestamp = (Get-Date -Format o); event = "postToolUse"; attestationFile = $AttestationFile; info = "No attestation file found. Skipping truthfulness check." }
    Add-Content -Path $IntegrityLog -Value ($attnLog | ConvertTo-Json -Compress)
    # No attestation file to back up or read back
    try {
        $fs = [System.IO.File]::Open($IntegrityLog, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::ReadWrite)
        $fs.Flush($true)
        $fs.Close()
    } catch { Write-Warning "[fsync] Failed to flush ${IntegrityLog}: $_" }
    if ($Verbose) { Write-Host "No attestation file found. Skipping truthfulness check." -ForegroundColor Yellow }
}

if ($Verbose) { Write-Host "[postToolUse] Integrity and truthfulness checks complete. Hash: $hash" -ForegroundColor Green }
else { Write-Host "[postToolUse] Complete." -ForegroundColor Green }
exit 0
