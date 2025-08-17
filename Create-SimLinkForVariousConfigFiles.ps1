# --- Self-elevate if not running as admin ---
$curr = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($curr)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Restarting script with administrator privileges..."
    try {
        Start-Process -FilePath 'powershell.exe' `
            -ArgumentList @(
                '-NoProfile'
                '-ExecutionPolicy','Bypass'
                '-File', $PSCommandPath
            ) -Verb RunAs
    } catch {
        Write-Host "User cancelled elevation." -ForegroundColor Red
    }
    exit
}

$ErrorActionPreference = 'Stop'
$psProfPath = Split-Path -Parent $PROFILE

$pairs = @(
    @{ Repo = 'C:\src\terminal\settings.json'; Local = (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json') },
    @{ Repo = 'C:\src\vscode\settings.json';   Local = "C:\Users\$env:USERNAME\AppData\Roaming\Code\User\settings.json" },
    @{ Repo = 'C:\src\vscode\keybindings.json';Local = "C:\Users\$env:USERNAME\AppData\Roaming\Code\User\keybindings.json" },
    @{ Repo = 'C:\src\powershell\profile.ps1'; Local = "$psProfPath\profile.ps1" }
)

foreach ($pair in $pairs) {
    $repoPath  = $pair.Repo
    $localPath = $pair.Local
    $parentDir = Split-Path -Parent $localPath

    if (-not (Test-Path -LiteralPath $repoPath)) {
        Write-Warning ("Repo file not found: {0} - skipping." -f $repoPath)
        continue
    }

    if (-not (Test-Path -LiteralPath $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }

    if (Test-Path -LiteralPath $localPath) {
        $answer = Read-Host ("{0} already exists. Overwrite with symlink to {1}? (y/n)" -f $localPath, $repoPath)
        if ($answer -ne 'y') { continue }

        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        Copy-Item -LiteralPath $localPath -Destination ("{0}.bak-{1}" -f $localPath,$stamp)
        Remove-Item -LiteralPath $localPath -Force
    }

    # Create the symlink (file link)
    Write-Host ("Linking: {0} -> {1}" -f $localPath, $repoPath)
    New-Item -ItemType SymbolicLink -Path $localPath -Target $repoPath | Out-Null
}