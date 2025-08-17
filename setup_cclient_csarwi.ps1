$applications = @(
    'git.install',
    'microsoft-windows-terminal',
    '7zip.install',
    'vscode.install',
    'winscp.install'
    'nerd-fonts-firacode'
    'oh-my-posh'

)

# Install each application from Chocolatey
foreach ($app in $applications) {
    Write-Host "Installing $app..."
    choco install $app -y
}

Write-Host "All applications have been installed."

#Make hidden files and folders visible
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $regPath -Name Hidden -Value 1     # Make hidden files visible
Set-ItemProperty -Path $regPath -Name ShowSuperHidden -Value 1 # Make system files visible

#Always show file extensions
Set-ItemProperty -Path $regPath -Name HideFileExt -Value 0  # Show file extensions

