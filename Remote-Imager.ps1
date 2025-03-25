<#
.SYNOPSIS
    This script remotely manages a list of computers, specifically to remove applications via a PowerShell script. It creates PowerShell sessions, runs commands to remove specific software, and manages the list of computers dynamically based on the provided parameters.

.DESCRIPTION
    This script allows for remotely managing computers on a network, specifically for the purpose of removing unwanted software (e.g., via a script like RemoveApplications.ps1). The script is designed to dynamically generate computer names, establish remote sessions using PowerShell remoting, and invoke commands on multiple remote machines. 

.PARAMETER site
    The site or domain name (default is "ComputerName"). This is used as part of the generated computer names (e.g., Company-PC01, Company-PC02).

.PARAMETER pctype
    The type of the computer (default is "PC"). This is used in the generated computer name (e.g., Company-PC01, Company-PC02).

.PARAMETER start
    The starting number for generating computer names (default is 1). The script will generate computer names starting from this value.

.PARAMETER end
    The ending number for generating computer names (default is 1). The script will generate computer names up to this value.

.PARAMETER user
    The domain and username for authentication to the remote machines (default is "Domain\Username").

.EXAMPLE
    .\Script.ps1 -site "Company" -pctype "PC" -start 1 -end 5 -user "Domain\admin"
    This would generate computer names like Company-PC01, Company-PC02, ..., Company-PC05, then attempt to remove applications from those computers.

#>

param(
    [string]$site = "ComputerName",    # The site or domain name used to generate the computer name
    [string]$pctype = "PC",            # The type of the computer used in generating the computer name
    [int]$start = 1,                   # The starting index for generating computer names
    [int]$end = 1,                     # The ending index for generating computer names
    [string]$user = "Domain\Username"  # The user for authentication to remote computers
)

# Set the execution policy for the remote computer
Set-ExecutionPolicy RemoteSigned -Scope Process

# Preset array for the computer names
$pcs = @()

# Loop through the range of computers
for ($x = $start; $x -le $end; $x++) {
    # Format the number to match two digits (e.g., 01, 02, 03)
    $formattedIndex = $x.ToString("D2")

    # Generate the computer name by joining the site, pctype, and the formatted index
    $pc = "$site-$pctype$formattedIndex"

    # Add the computer name to the array
    $pcs += $pc
}

# Output the list of computer names
$pcs

# Pause for 2 seconds
Start-Sleep -Seconds 2

# Remove any existing sessions
Get-PSSession | Remove-PSSession

# Clear the trusted hosts
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '' -Force

# Provide Credentials
Write-Host "Provide Credentials for $user"
$cred = Get-Credential $user

$path = $PSScriptRoot + "Remote-Scripts\"
# Paths for the scripts
$createshortcuts = "$path + \createshortcuts.ps1"
$changeUser = "$path + \changeUsers.ps1"
$removeApps = "$path + \to\RemoveApplications.ps1"
$installApps = "$path + \to\softwareInstall.ps1"

# Create sessions
$sessions = @()

# Remove any existing sessions
Get-PSSession | Remove-PSSession

# Make sure to sign in to the PC with the intended user first
Write-Host "Make sure to sign in to the PC with the intended user first and computer names are correct." -ForegroundColor Yellow
Read-Host "press any key to continue or ctrl+c to exit"

foreach ($computerName in $pcs) {
    # Set the trusted hosts for the remote computer
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $computerName -Force
    Write-Host "Trusted Host Set for $computerName"

    # Create a new session with the remote computer
    $session = New-PSSession -ComputerName $computerName -Credential $cred
    $sessions += $session
}

# Run commands on all sessions
foreach ($session in $sessions) {
    Invoke-Command -Session $session -FilePath $createshortcuts
    Invoke-Command -Session $session -FilePath $changeUser
    Invoke-Command -Session $session -FilePath $installApps -ArgumentList "C:\Users\$user\Desktop\nable", "silent" # verify username
    Invoke-Command -Session $session -FilePath $removeApps
}

# Remove sessions
Get-PSSession | Remove-PSSession
