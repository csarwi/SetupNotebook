# List of applications to install via Chocolatey
$applications = @(
    'GoogleChrome',
    'git.install',
    'notepadplusplus.install',
    '7zip.install',
    'vscode.install',
    'zoom',
    'winscp.install'

)

# Install each application from Chocolatey
foreach ($app in $applications) {
    Write-Host "Installing $app..."
    choco install $app -y
}

Write-Host "All applications have been installed."

# Download and install latest FilePilot
$Url = "https://filepilot.tech/download/latest"
$Installer = "$env:TEMP\FilePilotInstaller.exe"
Start-BitsTransfer -Source $Url -Destination $Installer
Start-Process $Installer -Wait

# Create download directory
$DownloadPath = "$env:TEMP\Installers"
New-Item -ItemType Directory -Path $DownloadPath -Force | Out-Null

# Define download list (URL, filename)
$files = @(
    @{ Url = "https://om-apps.com/csa/om_software/sophosSetup.exe"; FileName = "sophosSetup.exe" }
    @{ Url = "https://om-apps.com/csa/om_software/swyx.msi"; FileName = "swyx.msi" }
    @{ Url = "https://om-apps.com/csa/om_software/snagitde.exe"; FileName = "snagitde.exe" }
    @{ Url = "https://om-apps.com/csa/om_software/watchguard.exe"; FileName = "watchguard.exe" }
    @{ Url = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"; FileName = "chrome_installer.exe"}
    @{ Url = "https://om-apps.com/csa/om_software/CitrixWorkspaceApp.exe"; FileName = "CitrixWorkspaceApp.exe" }
    @{ Url = "https://c.1password.com/dist/1P/win8/1PasswordSetup-latest.msixbundle"; FileName = "1PasswordSetup.msixbundle" }
    @{ Url = "https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe"; FileName = "TeamViewer_Setup_x64.exe" }
    @{ Url = "https://links.fortinet.com/forticlient/win/vpnagent"; FileName = "FortiClientVPNInstaller.exe" }
    @{ Url = "https://download3.omnissa.com/software/CART26FQ2_WIN_2506/Omnissa-Horizon-Client-2506-8.16.0-16560451995.exe"; FileName = "OmnissaHorizonClient.exe" }
    @{ Url = "https://software.sonicwall.com/GlobalVPNClient/184-011921-00_REV_A_GVCSetup64.exe"; FileName = "GVCSetup64.exe" }
)

# Download files using BITS
foreach ($file in $files) {
    $destination = Join-Path $DownloadPath $file.FileName
    Write-Host "Downloading $($file.FileName) using BITS..."
    Start-BitsTransfer -Source $file.Url -Destination $destination
}

# Install each file
foreach ($file in $files) {
    $installer = Join-Path $DownloadPath $file.FileName
    Write-Host "Executing installer: $($file.FileName)..."
    Start-Process -FilePath $installer -PassThru
}

Write-Host "All installers have been executed."


# Install Fonts

# Download & install fonts
$FontUrls = @(
    'https://om-apps.com/csa/om_software/FTB.TTF', 
    'https://om-apps.com/csa/om_software/FTL.TTF' 
)

$FontDownloadDir = Join-Path $env:TEMP 'Fonts'
New-Item -ItemType Directory -Path $FontDownloadDir -Force | Out-Null

foreach ($url in $FontUrls) {
    $dest = Join-Path $FontDownloadDir ([IO.Path]::GetFileName($url))
    Write-Host "Downloading font: $([IO.Path]::GetFileName($url)) ..."
    Start-BitsTransfer -Source $url -Destination $dest

    # If the file was provided as .tff, correct to .ttf
    if ($dest -match '\.tff$') {
        $fixed = [IO.Path]::ChangeExtension($dest, '.ttf')
        Rename-Item -Path $dest -NewName ([IO.Path]::GetFileName($fixed)) -Force
        $dest = $fixed
    }

    # Install into Windows Fonts using the Shell COM (registers the font)
    $shell = New-Object -ComObject Shell.Application
    $fontsFolder = $shell.Namespace(0x14)  # Fonts special folder
    Write-Host "Installing font: $([IO.Path]::GetFileName($dest)) ..."
    $fontsFolder.CopyHere($dest)
}

Write-Host "Fonts installed."