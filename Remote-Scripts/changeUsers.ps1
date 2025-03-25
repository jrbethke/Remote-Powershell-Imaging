<#
.SYNOPSIS
    Manages local user accounts by checking if an account exists and performing actions such as deletion, profile removal, demotion, or creation based on user input.

.DESCRIPTION
    This script interacts with local user accounts, providing the following capabilities:
    - Checks if a specified local user account exists on the machine.
    - If the user exists, options include:
        - Deleting the user account.
        - Deleting the user's associated profile files.
        - Demoting the user from the "Administrators" group.
    - If the user does not exist, the script offers the option to create a new local user account without a password.
    - User input is prompted at runtime to determine the actions to be taken.

.PARAMETER username
    Specifies the username of the local account to manage. Default is "user".

.PARAMETER deleteHost
    Indicates whether to delete the specified local account. Acceptable values are "yes" or "no". Default is "no".

.PARAMETER deleteProfile
    Specifies whether to delete the user's associated profile files. Acceptable values are "yes" or "no". Default is "no".

.PARAMETER check
    Specifies whether to create the user account if it does not exist. Acceptable values are "yes" or "no". Default is "no".

.EXAMPLE
    .\changeUsers.ps1 -username "user" -create "yes"
    Runs the script to create a user named "user"

    .\changeUsers.ps1 -username "user" -deleteHost "yes" -deleteProfile "yes"
    Runs the script to delete the user "user"

.NOTES
    File Name      : changeUsers.ps1
    Author         : Jesse Bethke
    Version        : 1.2
    Date Updated   : 11/21/2024
    Purpose        : Provides comprehensive management of local user accounts (create, delete, profile cleanup, demote).
    Prerequisites  : Run as Administrator to ensure sufficient privileges to modify user accounts and profiles.
    Dependencies   : Uses PowerShell cmdlets such as Get-LocalUser, Remove-LocalUser, New-LocalUser, and Remove-CimInstance.
#>

param (
    [string]$username = "user",    # Default username to modify
    [string]$deleteHost = "yes",    # Default for deleting host $username
    [string]$deleteProfile = "yes", # Default  for delete $username files
    [string]$create = "no"          # Default answer for creating a user defined by username if it does not exist
)

# Check if the user account exists
$userExists = Get-LocalUser -Name $username -ErrorAction SilentlyContinue

# Handle the case where the user exists
if ($userExists) {
    # If the user wants to delete the existing user
    if ($deleteHost -like "yes" -or $deleteHost -like "y") {
        # Delete the user account
        Remove-LocalUser -Name $username
        Write-Host "User '$username' has been deleted."
        return
    }
    
    if ($deleteProfile -like "yes" -or $deleteProfile -like "y") {
        # Delete the user profile associated with the account
        $userprofile = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath -like "*$username" }
        $userprofile | Remove-CimInstance
        Write-Host "User profile for '$username' has been deleted."
    }

    # If not deleting, demote the user from the Administrators group
    Remove-LocalGroupMember -Group "Administrators" -Member $username
    Write-Host "User '$username' has been demoted."

} else {
    # Handle the case where the user does not exist
    if ($create -like "yes" -or $create -like "y") {
        # Create the user with no password
        New-LocalUser -Name $username -NoPassword
        Write-Host "User '$username' has been created with no password."
    } else {
        Write-Host "No user exists, and no account will be created."
    }
}
