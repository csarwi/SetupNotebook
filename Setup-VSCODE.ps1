# Check if VSCode is installed
$vsCodePath = Get-Command "code" -ErrorAction SilentlyContinue

if (-not $vsCodePath) {
    Write-Host "Visual Studio Code is not installed on this machine."
    exit
}

# List of VSCode extensions to install (add more as needed)
$extensions = @(
    "ms-python.python",            # Python Extension
    "ms-vscode.powershell",        # PowerShell Extension
    "eamodio.gitlens",             # GitLens Extension (Git tree visualization)
    "GitHub.vscode-pull-request-github", # GitHub Pull Requests & Issues (GitHub integration)
    "mhutchie.git-graph"           # Git Graph Extension (Git tree visualization)
)

# Loop through each extension and install it
foreach ($extension in $extensions) {
    Write-Host "Installing extension: $extension..."
    Start-Process -FilePath "code" -ArgumentList "extension install $extension" -Wait
}

Write-Host "Extensions installed successfully."
