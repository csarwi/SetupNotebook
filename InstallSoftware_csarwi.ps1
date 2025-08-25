# Run this in PowerShell as Administrator

& choco install python
& choco install ilspy
& choco install autohotkey
& choco install postman
& choco install nerd-fonts-firacode
& choco install oh-my-posh
& choco install nerd-fonts-cascadiacode
& choco install warp-terminal
& choco install fzf
& chocho install obs-studio
& choco install writage

git config --global user.name "Reto Wietlisbach"
git config --global user.email = "rwietlisbach@creativ.ch"
Write-Host "Set github user.name and user.email"

Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force

if (-not (Test-Path "C:\src")) {
	mkdir C:\src
	Write-Host "Created C:\src"
}
Write-Host "C:\src already existed" -ForegroundColor Yellow


winget install 9NKSQGP7F2NH #WhatsAPP
winget install 9NT1R1C2HH7J #ChatGPT from OpenAI
winget install 9PF4KZ2VN4W9 #TranslucentTB
choco install visualstudio2022community
winget install "Microsoft PowerToys"

choco install mingw
choco install -y neovim git ripgrep wget fd unzip gzip make
git clone https://github.com/csarwi/kickstart.nvim.git "${env:LOCALAPPDATA}\nvim"

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell -All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All -All

#make taskbar dissapear automatically. 
$Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
$Name = 'Settings'
# Ensure value exists and is binary
$item = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop
if (-not ($item.$Name -is [byte[]])) {
 throw "Unexpected type: $Name is not REG_BINARY." 
}

# Backup current bytes so you can undo
$backup = $item.$Name.Clone()
$backup | Set-Content -Encoding Byte -Path "$env:TEMP\StuckRects3-Settings.backup.bin"

$bytes = $item.$Name
$bytes[8] = if ($bytes[8] -eq 3) {
 2 
}
else {
 3 
}
# Write back and restart Explorer
Set-ItemProperty -Path $Path -Name $Name -Value $bytes
Stop-Process -Name explorer -Force

powercfg -setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
powercfg -setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 0
powercfg -SetActive SCHEME_CURRENT
