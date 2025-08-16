# --- Self-elevate if not running as admin ---
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {

    Write-Host "Restarting script with administrator privileges..."
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = 'powershell.exe'
    $psi.Arguments = "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    $psi.Verb = 'runas'  # triggers UAC prompt
    try {
        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        Write-Host "User cancelled elevation." -ForegroundColor Red
    }
    exit
}

$pairs = @(
    @{ Repo = "C:\src\terminal\settings.json"; Local = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json' },
    @{ Repo = "C:\src\vscode\settings.json"; Local = "C:\Users\$env:USERNAME\AppData\Roaming\Code\User\Settings.json" }
    @{ Repo = "C:\src\vscode\keybindings.json"; Local = "C:\Users\$env:USERNAME\AppData\Roaming\Code\User\keybindings.json" }
)

# --- Loop over each pair ---
foreach ($pair in $pairs) {
    $RepoJson = $pair.Repo
    $WtLocal  = $pair.Local

    # Make sure repo is cloned before running this

    # Backup local settings
    if (Test-Path $WtLocal) {
        $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
        Copy-Item $WtLocal "$WtLocal.bak-$stamp"
        Remove-Item $WtLocal -Force
    }

    # Create symlink
    $cmd = 'mklink "{0}" "{1}"' -f $WtLocal, $RepoJson
    cmd /c $cmd
}
