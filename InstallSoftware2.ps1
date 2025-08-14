# Create download directory
$DownloadPath = "$env:TEMP\Installers"
New-Item -ItemType Directory -Path $DownloadPath -Force | Out-Null

# Define download list (URL, filename)
$files = @(
    @{ Url = "https://om-apps.com/csa/om_software/sophosSetup.exe?key=soonnew123"; FileName = "sophosSetup.exe" }
    @{ Url = "https://om-apps.com/csa/om_software/swyx.msi?key=soonnew123"; FileName = "swyx.msi" }
    @{ Url = "https://om-apps.com/csa/om_software/snagitde.exe?key=soonnew123"; FileName = "snagitde.exe" }
    @{ Url = "https://om-apps.com/csa/om_software/watchguard.exe?key=soonnew123"; FileName = "watchguard.exe" }
    @{ Url = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"; FileName = "chrome_installer.exe}
    @{ Url = "https://om-apps.com/csa/om_software/CitrixWorkspaceApp.exe?key=soonnew123"; FileName = "CitrixWorkspaceApp.exe" }
    @{ Url = "https://c.1password.com/dist/1P/win8/1PasswordSetup-latest.msixbundle"; FileName = "1PasswordSetup.msixbundle" }
    @{ Url = "https://download.teamviewer.com/download/TeamViewer_Setup_x64.exe"; FileName = "TeamViewer_Setup_x64.exe" }
    @{ Url = "https://links.fortinet.com/forticlient/win/vpnagent"; FileName = "FortiClientVPNInstaller.exe" }
    @{ Url = "https://download3.omnissa.com/software/CART26FQ2_WIN_2506/Omnissa-Horizon-Client-2506-8.16.0-16560451995.exe"; FileName = "OmnissaHorizonClient.exe" }
    @{ Url = "https://software.sonicwall.com/GlobalVPNClient/184-011921-00_REV_A_GVCSetup64.exe"; FileName = "GVCSetup64.exe" }
)

# Download files
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