# 1. Remove FortiClient from Autostart (check registry for startup keys)
$autostartRegistryKeys = @(
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
    "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($key in $autostartRegistryKeys) {
    $fortiClientKey = Get-ItemProperty -Path $key | Where-Object { $_.PSChildName -like "*FortiClient*" }
    if ($fortiClientKey) {
        Write-Host "Found FortiClient autostart entry, removing it..."
        Remove-ItemProperty -Path $key -Name $fortiClientKey.PSChildName
    }
}

# 2. Make hidden files and folders visible
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $regPath -Name Hidden -Value 1     # Make hidden files visible
Set-ItemProperty -Path $regPath -Name ShowSuperHidden -Value 1 # Make system files visible

# 3. Always show file extensions
Set-ItemProperty -Path $regPath -Name HideFileExt -Value 0  # Show file extensions

Stop-Process -Name explorer -Force
Start-Process explorer

Write-Host "Changes applied successfully."
