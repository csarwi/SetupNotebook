
# --- Config ---
$RepoDir   = "C:\src\terminal"
$RepoJson  = Join-Path $RepoDir "settings.json"
$WtLocal   = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'

# Ensure repo directory exists
New-Item -ItemType Directory -Path $RepoDir -Force | Out-Null

# Ensure Windows Terminal is closed (best practice to avoid write races)
$wtProc = Get-Process -Name WindowsTerminal -ErrorAction SilentlyContinue
if ($wtProc) {
    Write-Host "Please close Windows Terminal before continuing..." -ForegroundColor Yellow
    Read-Host "Press Enter once it's closed"
}

# 1) Verify original exists
if (-not (Test-Path $WtLocal)) {
    Write-Host "Could not find WT settings at:`n$WtLocal" -ForegroundColor Red
    Write-Host "Is this a Store install? If not, the unpackaged path is: $($env:LOCALAPPDATA)\Microsoft\Windows Terminal\settings.json"
    return
}

# 2) Copy original to repo (preserve content)
Copy-Item -Path $WtLocal -Destination $RepoJson -Force

# 3) Backup the original in place
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupPath = Join-Path (Split-Path $WtLocal -Parent) ("settings.json.bak-$stamp")
Copy-Item -Path $WtLocal -Destination $BackupPath -Force

# 4) Replace original with a symlink pointing to repo
#    mklink requires the link path not to exist, so remove the file (we have a backup)
Remove-Item $WtLocal -Force

# Create the symlink (file link)
$cmd = 'mklink "{0}" "{1}"' -f $WtLocal, $RepoJson
cmd /c $cmd | Out-Host

# 5) Done
Write-Host "`nAll set! WT now uses your repo file:" -ForegroundColor Green
Write-Host "  Link: $WtLocal"
Write-Host " Target: $RepoJson"
Write-Host "Backup kept at: $BackupPath"