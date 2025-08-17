# Ensure script runs as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    exit
}

# NOTE: This might actually take a while :) 

if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host "Installing PSWindowsUpdate module..."
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module -Name PSWindowsUpdate -Force -AllowClobber

}

# Import the module
Import-Module PSWindowsUpdate

# Enable Windows Update Service
Get-Service wuauserv | Set-Service -StartupType Manual
Start-Service wuauserv

# Update loop
do {
    Write-Host "Checking for updates..."
    $Updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot

    if ($Updates) {

	Write-Host "`nUpdates found:"
        
        # Print out each update's details
        foreach ($update in $Updates) {
            Write-Host "Title: $($update.Title)"
            Write-Host "KB Article: $($update.KBArticleIDs)"
            Write-Host "Description: $($update.Description)"
            Write-Host "-------------------------"
        }

        Write-Host "`nInstalling updates..."
        Install-WindowsUpdate -AcceptAll -IgnoreReboot -AutoReboot
        Write-Host "Rebooting if necessary..."
    } else {
        Write-Host "`nNo more updates available. System is up to date."
    }


} while ((Get-WindowsUpdate -AcceptAll -IgnoreReboot).Count -gt 0)

Write-Host "`n✅ All updates installed!"
Write-Host "In the Windows "Updates"-GUI it might still list many updates; just Click 'Download & Install'. It will then realise that those are actually already installed."