<#
.SYNOPSIS
    This script removes specified software from a system using winget. It defines a list of software to be removed and checks if each software is installed on the system. If it is, it will uninstall the software silently and forcefully.

.DESCRIPTION
    This script is designed to uninstall unwanted software from a system using the `winget` package manager. It checks for a predefined list of software, searches for matching entries by name or ID, and removes them if found. The script also updates all installed packages using `winget` after removing the software.

.PARAMETER removeApps
    A hashtable that contains the name of the software to be removed as the key and the corresponding pattern (name or ID) used to identify the software in the installed list as the value. 

.EXAMPLE
    .\RemoveSoftware.ps1
    This script will run and remove all software from the predefined list. If the software is found on the system, it will be removed silently and forcefully.

.NOTES
    Author: Your Name
    Date: MM/DD/YYYY
    Dependencies: Requires winget installed on the system for package management.
#>

# Define the list of software to be removed
Set-ExecutionPolicy Bypass -Scope Process -Force

# Hashtable containing the software names and their respective patterns to search for during uninstallation
$removeApps = @{
    "Adobe Acrobat (64-bit)"        = "*Adobe* *Acrobat* *64-bit*"
    "OpenOffice 4.1.13"             = "*OpenOffice* *4.1.13*"
    "OpenOffice 4.1.15"             = "*OpenOffice* *4.1.15*"
    "Xbox Game Bar"                 = "*Xbox* *Game*"
    "Xbox Live"                     = "*Xbox* *Live*"
    "Zoom(64bit)"                   = "*Zoom* *5.8.3* *64-bit*"
    "Zoom Workplace (64-bit)"       = "*Zoom* *Workplace* *5.8.3* *64-bit*"
    "McAfee"                        = "*McAfee*"
    "Microsoft Buy"                 = "*StorePurchaseApp*"
    "Microsoft Teams (Personal)"    = "*Microsoft* *Teams* *Personal*"
    "BingNews"                      = "*bingNews*"
    "Bing Weather"                  = "*BingWeather*"
    "Microsoft Store"               = "*WindowsStore*"
    "Your Phone"                    = "*YourPhone*"
    "Solitaire"                     = "*Solitaire*"
    "Xbox Gaming Overlay"           = "*XboxGamingOverlay*"
    "Xbox"                          = "*Xbox*"
    "Xbox TCUI"                     = "*Xbox* *TCUI*"
    "Game Bar"                      = "*Game* *Bar*"
    "Xbox Identity Provider"        = "*Xbox* *Identity* *Provider*"
    "Game Speech Window"            = "*Game* *Speech* *Window*"
    "Phone Link"                    = "*Phone* *Link*"
    "Windows Web Experience Pack"   = "*Windows* *Web* *Experience* *Pack*"
    "Cross Device Experience Pack"  = "*Cross* *Device* *Experience* *Pack*"
    "Store Experience Host"         = "*Store* *Experience* *Host*"
    "Xbox Game Bar Plugin"          = "*Xbox* *Game* *Bar* *Plugin*"
    "Xbox Speech2text"              = "*SpeechToText*"
    "Solitaire & Casual Games"      = "*Solitaire* *Casual* *Games*"
}

# Get list of installed packages and filter through installed apps
winget list --accept-source-agreements | Out-Null

# Compare and remove software from the list
foreach ($app in $removeApps.GetEnumerator()) {
    Write-Host "Looking for software: $($app.Key)"

    # Search for the software in the installed list (by name or id)
    $installedApp = winget list | Select-String -Pattern $app.Value

    if ($installedApp) {
        # If the software is found, uninstall it silently and forcefully
        winget uninstall --name $app.Key --silent --force | Out-Null
        Write-Host "Software removed: $($app.Key)" -ForegroundColor Green
    } 
    else {
        Write-Host "Software not found: $($app.Key)" -ForegroundColor Yellow
    }
}

# Update all installed winget packages
winget upgrade --all
