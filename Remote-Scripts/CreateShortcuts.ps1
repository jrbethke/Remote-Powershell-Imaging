<#
.SYNOPSIS
    Creates shortcuts for websites on the public desktop.

.DESCRIPTION
    This script creates shortcuts for specified websites on the public desktop using Google Chrome.
    It supports multiple websites, and each shortcut is created with a custom description.

    The URLs and descriptions for the website shortcuts are configurable via parameters. More shortcuts can be added 
    by extending the input arrays of URLs and descriptions. Each URL will be paired with its corresponding description.

.PARAMETER $urls
    An array of URLs for the website shortcuts. Defaults to:
    - "https://accounts.pointclickcare.com/#/login"

.PARAMETER $descriptions
    An array of descriptions for each website shortcut. Each description will be used in the shortcut name. Defaults to:
    - "PCC"

.EXAMPLE
    .\CreateShortcuts.ps1
    This will create shortcuts on the public desktop:
    - A shortcut for "PCC" (points to https://accounts.pointclickcare.com/#/login)

    The created shortcuts will appear on the public desktop for all users.

.EXAMPLE
    .\CreateShortcuts.ps1 -urls "https://example.com", "https://another-example.com" -descriptions "ExampleSite", "AnotherSite"
    This will create two shortcuts pointing to the specified URLs with the given descriptions.

.NOTES
    File Name      : CreateShortcuts.ps1
    Author         : Jesse Bethke
    Version        : 1.1
    Date Created   : 11/08/2024
    Purpose        : To create website shortcuts on the public desktop for all users.
    Prerequisites  : Requires Google Chrome to be installed on the machine for the website shortcuts.
    Dependencies   : Requires access to the `WScript.Shell` COM object for shortcut creation.

#>


# Define the parameters for website URLs and descriptions
param (
    [string[]]$urls = @("https://accounts.pointclickcare.com/#/login"), # Default URL no arg passed in
    [string[]]$descriptions = @("PCC") # Default Description 
)

# Iterate over the arrays and create shortcuts for each URL and description pair
for ($i = 0; $i -lt $urls.Length; $i++) {
    $url = $urls[$i]
    $description = $descriptions[$i]

    # Create the shortcut
    $shortcutPath = "C:\Users\Public\Desktop\$($description).lnk"  # Dynamically naming shortcut based on description
    $Shell = New-Object -ComObject WScript.Shell
    $shortcut = $Shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
    $shortcut.Arguments = $url
    $shortcut.Description = $description
    $shortcut.WindowStyle = 1  # Normal window
    $shortcut.Save()

    Write-Output "Shortcut created for $description at $shortcutPath"
}