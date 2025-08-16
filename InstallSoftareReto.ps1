& choco install python
& choco install ilspy
& choco install autohotkey
& choco install postman
& choco install nerd-fonts-firacode
& choco install oh-my-posh
& choco install nerd-fonts-cascadiacode


git config --global user.name "Reto Wietlisbach"
git config --global user.email = "rwietlisbach@creativ.ch"


$urlFilePilot = 'https://filepilot.tech/download/latest'
$tempPathFilePilot = "$ENV"


Write-Host "Set github user.name and user.email"

if(-not (Test-Path "C:\src"))
{
    mkdir C:\src
    Write-Host "Created C:\src"
}
Write-Host "C:\src already existed" -ForegroundColor Yellow


winget install 9NKSQGP7F2NH #WhatsAPP
winget install 9NT1R1C2HH7J #ChatGPT from OpenAI
winget install 9PF4KZ2VN4W9 #TranslucentTB
choco install studio
choco install visualstudio2022community
winget install "Microsoft PowerToys"

& choco install neovim

# Run this in PowerShell as Administrator
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell -All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All -All



#make taskbar dissapear automatically. 
    # Safer toggle with backup + validation
    $Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
    $Name = 'Settings'

    # Ensure value exists and is binary
    $item = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop
    if (-not ($item.$Name -is [byte[]])) { throw "Unexpected type: $Name is not REG_BINARY." }

    # Backup current bytes so you can undo
    $backup = $item.$Name.Clone()
    $backup | Set-Content -Encoding Byte -Path "$env:TEMP\StuckRects3-Settings.backup.bin"

    # Flip byte 8: 3 = autohide ON, 2 = OFF
    $bytes = $item.$Name
    $bytes[8] = if ($bytes[8] -eq 3) { 2 } else { 3 }
    
    # Write back and restart Explorer
    Set-ItemProperty -Path $Path -Name $Name -Value $bytes
    Stop-Process -Name explorer -Force


Import-Module BitsTransfer

$source = "https://filepilot.tech/download/filepilot-0.2.8-installer.exe"
$destination = "$env:USERPROFILE\Downloads\FilePilot-0.2.8.exe"

Start-BitsTransfer -Source $source -Destination $destination

# Optional: Silent install
Start-Process -FilePath $destination -ArgumentList "/S" -Wait
