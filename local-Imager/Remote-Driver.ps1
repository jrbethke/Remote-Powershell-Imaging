# Windows Imaging script to prepare laptops/workstations
# Created 3/19/2025
# Author Jesse Bethke


# Setting the execution policy to allow scripts to run
Set-ExecutionPolicy RemoteSigned
$path = $PSScriptRoot + "\scripts\"

# Define the script execution order
$order = @(
    "add-wifi.ps1",
    "software-install.ps1",
    "syncDateTime.ps1",
    "Domain-Join.ps1",
    "Remote-Powershell-Enable.ps1"
    "RemoveApplications.ps1"
)

foreach ($ps in $order) {
    Try {
        Write-Host "Executing $ps"
        $psPath = $path + $ps
        write-host "$psPath"
        & $psPath
    }
    Catch {
        Write-Host "Error with $ps, check if it exists"
        Write-Error "Error: $_"
    }
}

