<#
.SYNOPSIS
    Installs any software package found in a specified directory.

.DESCRIPTION
    This script searches for installer files in a given directory (relative to the script's location by default). 
    It installs each found package silently, waits for each installation to complete, and then attempts to clean up any temporary files.

.PARAMETER InstallPath
    The path to the directory where the installers are located. Default is relative to the script location under `installs\`.

.PARAMETER Verbosity
    Controls the level of output shown during installation. Options:
    - `silent`: Suppress most output and run the installation in quiet mode.
    - `verbose`: Show detailed output about the installation process.
    - `force`: Perform the installation with force (overrides some checks, more aggressive).

.EXAMPLE
    .\softwareInstall.ps1
    This will run the script and install all software packages found in the `installs\` directory next to the script.

.EXAMPLE
    .\softwareInstall.ps1 -InstallPath "D:\Software\Installers" -Verbosity "verbose"
    This will run the script with a custom install path and show detailed output.

.NOTES
    Author: Jesse Bethke
    Version: 1.1
    Date: 2024-11-08
#>

param (
    # The path to the directory where the installers are located (default to 'installs' subdirectory)
    [string]$InstallPath = (Join-Path -Path $PSScriptRoot -ChildPath "installs"),

    # Verbosity option to control script output
    [ValidateSet("silent", "verbose", "force")]
    [string]$Verbosity = "silent"
)

whoami.exe

# Set verbosity level for output
if ($Verbosity -eq "verbose") {
    $VerbosePreference = "Continue"
} elseif ($Verbosity -eq "silent") {
    $VerbosePreference = "SilentlyContinue"
} elseif ($Verbosity -eq "force") {
    $VerbosePreference = "Continue"
}

Write-Output "Setting local path to Installers"
Write-Verbose "Using Install Path: $InstallPath"

# Try block for installing software
Try {
    # Check if the specified install path exists
    if (-Not (Test-Path -Path $InstallPath)) {
        Write-Error "Install directory does not exist: $InstallPath"
        return
    }

    # Change to the installer directory
    Set-Location -Path $InstallPath

    # Get all installer files in the directory
    $installers = Get-ChildItem -File
    Write-Verbose "Found $($installers.Count) installer(s)"

    if ($installers.Count -eq 0) {
        Write-Host "No installers found in directory: $InstallPath"
        return
    }

    # Loop through each installer and run them
    foreach ($installer in $installers) {
        Write-Output "Starting installation of $($installer.Name)"

        # Set the local temp directory
        $LocalTempDir = $env:TEMP

        # Start the installer with silent install arguments
        Write-Verbose "Running $($installer.Name) with silent arguments"
        $process = Start-Process $installer.FullName -ArgumentList "/qn" -PassThru -Wait

        # Monitor the process until it completes
        $Process2Monitor = $process.Name

        # Check if the process is still running and wait for it to complete
        Do {
            $ProcessesFound = Get-Process | Where-Object { $_.Name -eq $Process2Monitor } | Select-Object -ExpandProperty Name
            if ($ProcessesFound) {
                Write-Host "Still running: $($ProcessesFound -join ', ')"
                Start-Sleep -Seconds 10
            }
        } Until (!$ProcessesFound)

        # Once the process has finished, cleanup the temporary directory
        Write-Verbose "Installation completed for $($installer.Name)"
        Try {
            # Clean up the installer from the temp directory (if needed)
            Remove-Item "$LocalTempDir\$($installer.Name)" -ErrorAction SilentlyContinue -Verbose
        }
        Catch {
            Write-Output "Error removing temp file: $_"
        }
    }

    # Go back to the previous directory
    Set-Location -Path $PSScriptRoot
}
catch {
    Write-Output "Error during installation: $($_.Exception.Message)"
}
