# Check if VSCode is installed
$vsCodePath = Get-Command "code" -ErrorAction SilentlyContinue

if (-not $vsCodePath) {
    Write-Host "Visual Studio Code is not installed on this machine. Install it ..."
    & choco install vscode.install
}

# List of VSCode extensions to install
$extensions = @(
    "ms-python.python",                  
    "ms-vscode.powershell",              
    "GitHub.vscode-pull-request-github", 
    "mhutchie.git-graph",                
    "enkia.tokyo-night",                 
    "gruntfuggly.todo-tree",             
    "ms-mssql.mssql"                     
    "vscodevim.vim"
)

# Get installed extensions
$installedExtensions = code --list-extensions

foreach ($extension in $extensions) {
    if ($installedExtensions -contains $extension) {
        Write-Host "Extension already installed: $extension"
    }
    else {
        Write-Host "Installing extension: $extension..."
        Start-Process -FilePath "code" -ArgumentList "--install-extension $extension" -Wait
    }
}

Write-Host "Extension installation check complete."

Write-Host "Get settings from github. com "

& git clone "https://github.com/csarwi/terminal" C:\src\terminal
& git clone "https://github.com/csarwi/vscode" C:\src\vscode
& git clone "https://github.com/csarwi/powershell" C:\src\powershell

Write-Host "Setting Simlinks for config files ..."
& .\Create-SimLinkForVariousConfigFiles.ps1
Write-Host "Copying other folders to ps-folder..."
$psProfPath = Split-Path -Parent $PROFILE
 
Get-ChildItem "C:\src\powershell" -Directory | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination $psProfPath -Recurse -Force 
}
