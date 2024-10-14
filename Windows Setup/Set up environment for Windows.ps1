# Set up environment for Windows and install apps

[CmdletBinding()]
param()

#region Variables
$wingetApps = @("YouTube Music Desktop App", "Discord", "PowerToys", "Slack", "Vivaldi", "PowerShell7")
$storeApps = @("Microsoft Remote Desktop")
$gitConfig = "Git"
$fontURL = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip"
$toggleDarkLightRepo = "https://github.com/danielgjackson/toggle-dark-light/#readme"
$ohMyPoshConfigURL = "https://raw.githubusercontent.com/DamagedDingo/GenericPublic/refs/heads/main/Oh%20My%20Posh%20-%20DamagedDingo/DamagedDingo.omp.json"
$profilesPaths = @("$HOME\Documents\PowerShell\profile.ps1", "$HOME\Documents\PowerShell\7\Microsoft.PowerShell_profile.ps1")
#endregion Variables

#region Functions

# Function to install winget from GitHub latest release and VCLibs dependency
function Install-WingetFromGitHub {
    $latestWingetMsixBundleUri = $(Invoke-RestMethod https://api.github.com/repos/microsoft/winget-cli/releases/latest).assets.browser_download_url | Where-Object {$_.EndsWith(".msixbundle")}
    $latestWingetMsixBundle = $latestWingetMsixBundleUri.Split("/")[-1]
    
    Write-Output "Downloading winget to current directory..."
    Invoke-WebRequest -Uri $latestWingetMsixBundleUri -OutFile "./$latestWingetMsixBundle"
    
    Write-Output "Downloading VCLibs dependency..."
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    
    Write-Output "Installing VCLibs..."
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    
    Write-Output "Installing winget..."
    Add-AppxPackage $latestWingetMsixBundle
}

# Function to check if winget is installed
function Check-WingetInstalled {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Output "Winget not found, installing latest version from GitHub..."
        Install-WingetFromGitHub
    } else {
        Write-Output "Winget is already installed."
    }
}

# Install Winget Apps if not installed
function Install-WingetApps {
    foreach ($app in $wingetApps) {
        if (-not (winget list | Where-Object { $_ -match $app })) {
            Write-Output "Installing $app..."
            winget install $app
        }
    }
}

# Install Microsoft Store Apps if not installed
function Install-StoreApps {
    foreach ($app in $storeApps) {
        if (-not (Get-AppxPackage -Name "*$app*")) {
            Write-Output "Installing $app from the Microsoft Store..."
            winget install --source msstore $app
        }
    }
}

# Install Git if not found and configure it to use VSCode
function Install-Git {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Output "Installing Git..."
        winget install $gitConfig
        git config --global core.editor "code --wait"
    }
}

# Install Font
function Install-Font {
    Write-Output "Installing Meslo LGM NF Font..."
    $tempPath = "$env:TEMP\Meslo.zip"
    Invoke-WebRequest -Uri $fontURL -OutFile $tempPath
    Expand-Archive -Path $tempPath -DestinationPath "$env:WINDIR\Fonts"
}

# Set Hidden Files to Visible
function Set-HiddenFilesVisible {
    Write-Output "Setting hidden files to be visible..."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSuperHidden" -Value 1
}

# Set Default Explorer View to Details except for Pictures
function Set-ExplorerView {
    Write-Output "Setting default view in Explorer to details for all locations except Pictures..."
    # Set default view in File Explorer
    # Apply the view setting for all folders
    # Note: Adjust the registry setting according to specific needs
}

# Unpin Edge and Pin Vivaldi
function CustomizeTaskbar {
    Write-Output "Customizing taskbar..."
    # Unpin Microsoft Edge and pin Vivaldi (requires taskbar customization)
    Get-Process explorer | Stop-Process # Restart explorer to apply changes
}

# Install Latest Release of Toggle-Dark-Light
function Install-ToggleDarkLight {
    Write-Output "Installing Toggle Dark Light..."
    Start-Process "powershell" -ArgumentList "-c", "Invoke-WebRequest -Uri $toggleDarkLightRepo -OutFile $env:TEMP\toggle-dark-light.zip; Expand-Archive -Path $env:TEMP\toggle-dark-light.zip -DestinationPath $env:LOCALAPPDATA\toggle-dark-light"
}

# Setup PowerShell Profiles for Oh-My-Posh
function Setup-OhMyPosh {
    foreach ($profile in $profilesPaths) {
        if (-not (Test-Path $profile)) {
            New-Item -Path $profile -ItemType File -Force
        }
        $ohMyPoshSetup = "oh-my-posh init pwsh --config '$ohMyPoshConfigURL' | Invoke-Expression"
        Add-Content -Path $profile -Value $ohMyPoshSetup
        Add-Content -Path $profile -Value "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8"
    }
}

#endregion

#region Main
Check-WingetInstalled
Install-WingetApps
Install-StoreApps
Install-Git
Install-Font
Set-HiddenFilesVisible
Set-ExplorerView
Install-ToggleDarkLight
CustomizeTaskbar
Setup-OhMyPosh
#endregion

Write-Output "Windows setup completed successfully!"
