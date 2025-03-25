# Define parameters for domain join
param(
    [string]$Domain="canc.compsys.com",
    [string]$Server="172.17.56.1",
    [string]$NewName ="CANC-SHI-PC06",
    [bool]$Restart,
    [bool]$Force
)

# Function to test connection to Domain Controller
function Test-DomainControllerConnection {
    param(
        [string]$Server
    )

    try {
        # Attempt to resolve the domain controller
        $isConnected = Test-Connection -ComputerName $Server -Count 1 -ErrorAction Stop
        if ($isConnected) {
            Write-Host "Successfully connected to domain controller '$Server'." -ForegroundColor Green
            return $true
        } else {
            Write-Host "Failed to connect to domain controller '$Server'." -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Failed to connect to domain controller '$Server'." -ForegroundColor Red
        return $false
    }
}
# Prompt for domain credentials
$cred = Get-Credential -Username "CANC\Compsystech" -Message "Please provide domain administrator credentials."

# Create a hashtable for splatting
#$domainJoinParams = @{
#    DomainName      = $Domain 
#    Credentials     = $Credential 
#    NewName         = $NewName                # Default to current computer name
#}

# Main logic to test domain controller and retry or cancel if failed
$retry = $true
while ($retry) {
    # Test domain controller connection
    $isConnected = Test-DomainControllerConnection -Server $Server
    
    # If connection successful, proceed with domain join
    if ($isConnected) {
        try {
            Add-Computer -Domain $Domain -NewName $NewName -Credential $cred
            Write-Host "Computer $NewName successfully joined to the domain." -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to join $ComputerName to the domain." -ForegroundColor Red
        }
        $retry = $false  # Exit loop after successful join
    } else {
        # If connection failed, give user option to retry or cancel
        $userChoice = Read-Host "Connection failed. Do you want to retry (Y) or cancel (N)?"

        if ($userChoice -like 'n' -or $userChoice -like 'N') {
            Write-Host "Domain join operation cancelled." -ForegroundColor Yellow
            $retry = $false  # Exit loop on cancel
        } elseif ($userChoice -like 'Y' -or $userChoice -like 'y') {
            Write-Host "Retrying..." -ForegroundColor Yellow
            # Retry logic will loop
        } else {
            Write-Host "Invalid input. Please enter 'Y' to retry or 'N' to cancel." -ForegroundColor Red
        }
    }
}
