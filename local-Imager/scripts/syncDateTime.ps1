<#
.SYNOPSIS
    Configures the Windows Time service and sets the system time zone.

.DESCRIPTION
    This script sets the system time zone, stops and starts the Windows Time service, unregisters and registers the service, 
    and performs a time synchronization. All these actions can be customized through parameters and verbosity options.

.PARAMETER TimeZone
    The time zone to set for the system. Default is "Central Standard Time".

.PARAMETER Verbosity
    Controls the level of output shown during the script's execution. Options:
    - `silent`: Suppresses most output and performs actions without display.
    - `verbose`: Shows detailed output during each action.
    - `force`: Force execution with detailed output, overriding some checks.

.EXAMPLE
    .\syncDateTime.ps1
    This will set the time zone to "Central Standard Time", stop/start the time service, 
    and synchronize the time using default actions.

.EXAMPLE
    .\syncDateTime.ps1 -TimeZone "Pacific Standard Time" -Verbosity "verbose"
    This will set the time zone to "Pacific Standard Time" and show detailed output.

.NOTES
    Author: Jesse Bethke
    Version: 1.1
    Date: 2024-11-08
#>

# The time zone to set on the machine. Default is "Central Standard Time".
$TimeZone = "Central Standard Time"

# Set the TimeZone
Write-Verbose "Setting Time Zone to $TimeZone"
Set-TimeZone -Name $TimeZone -PassThru

# Stop the Windows Time service
Write-Verbose "Stopping Windows Time service"
Stop-Service -Name w32time -Force

# Unregister the Windows Time service
Write-Verbose "Unregistering Windows Time service"
w32tm /unregister

# Register the Windows Time service
Write-Verbose "Registering Windows Time service"
w32tm /register

# Start the Windows Time service
Write-Verbose "Starting Windows Time service"
Start-Service -Name w32time

# Force a time synchronization
Write-Verbose "Resynchronizing time"
w32tm /resync /nowait

Write-Host "**Time configuration completed**"
