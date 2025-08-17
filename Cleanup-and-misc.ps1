# Set FortiClient Service Scheduler (FA_Scheduler) to Manual start
$serviceName = "FA_Scheduler"

try {
    # Check if the service exists
    $service = Get-Service -Name $serviceName -ErrorAction Stop
    
    if ($service) {
        # Change startup type to Manual
        Set-Service -Name $serviceName -StartupType Manual
        Write-Output "Service '$serviceName' was set to Manual successfully."
    }
}
catch {
    Write-Output "Error: Service '$serviceName' not found or could not be modified."
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
