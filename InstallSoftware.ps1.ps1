# PowerShell Script to Install Chocolatey and Applications

# Check if Chocolatey is installed
$chocoInstalled = Get-Command choco -ErrorAction SilentlyContinue

if (-not $chocoInstalled) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."

    # Set Execution Policy to RemoteSigned if required
    Set-ExecutionPolicy Bypass -Scope Process -Force

    # Install Chocolatey
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    Write-Host "Chocolatey installed successfully."
} else {
    Write-Host "Chocolatey is already installed."
}

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
