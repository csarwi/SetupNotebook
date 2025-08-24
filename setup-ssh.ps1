# Works in PowerShell 5.1

$desktop = [Environment]::GetFolderPath("Desktop")
$sshDir  = Join-Path $env:USERPROFILE ".ssh"
if (-not (Test-Path $sshDir)) { New-Item -ItemType Directory -Path $sshDir | Out-Null }

$workKey    = Join-Path $desktop "id_ed25519_work"
$privateKey = Join-Path $desktop "id_ed25519_private"

# Generate keys
ssh-keygen -t ed25519 -C "csarwi@$(hostname)" -f $workKey
ssh-keygen -t ed25519 -C "private@$(hostname)" -f $privateKey


Write-Host "`nPublic keys created on Desktop:`n"
Write-Host "Work:    $workKey.pub"
Write-Host "Private: $privateKey.pub`n"

Write-Host "=== Work key (csarwi) ==="
Get-Content "$workKey.pub"
Write-Host "`n=== Private key ==="
Get-Content "$privateKey.pub"


# Move into ~/.ssh
Copy-Item "$workKey*" $sshDir -Force
Copy-Item "$privateKey*" $sshDir -Force

# Write config
$configPath = Join-Path $sshDir "config"
$configContent = 
@"
# Default GitHub (Work)
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_work
    IdentitiesOnly yes

# Private GitHub
Host rewisch
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_private
    IdentitiesOnly yes
"@ 

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($configPath, $configContent, $utf8NoBom)

Write-Host "`nDone. Keys moved to $sshDir and config written at $configPath"

Write-Host "`nAdd the public-keys to your GitHub accounts, then press ENTER to continue..."
[void][System.Console]::ReadLine()

Remove-Item "$privateKey*" 
Remove-Item "$workKey*" 

Write-Host "Deleted files from desktop ..."
Write-Host "Test your connections with:"
Write-Host "  ssh -T git@github.com"
Write-Host "  ssh -T git@rewisch"
