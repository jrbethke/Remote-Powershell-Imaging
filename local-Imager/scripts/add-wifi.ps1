# Adds a wi-fi network as known network
$path = $PSScriptRoot
echo $path
# Get the available Wi-fi interface
$wifi = Get-NetAdapter | Where-Object { $_.Name -like "*Wi-Fi*" }
$String = $wifi.name
Write-Output "Interface to be selected: $wifi"

# tries to find the Wi-FI XML path. if it does not exists it is verbose about it
# XML should be same directory level as the script
$xml=Get-Item -path "$path\*.xml"
Write-Output "Looking for wi-fi profile at $xml"

# Attempt to add the Wi-Fi profile to known networks
Try{
    Write-Output "Trying to add the wifi to known networks"
    netsh wlan add profile filename="$xml" Interface="$String" user=current
    netsh wlan connect name="ATT938business"
}
 # Catch block executed if there's an error adding the Wi-Fi profile
 
catch { Write-Output "NO WIFI FOR YOU" }
# pauses script
Start-Sleep -Seconds 10

# Check if the computer has internet connectivity by pinging google.com
try {
    $bConnected = Test-Connection -ComputerName google.com -Count 1
    if ($bConnected.StatusCode -eq 0) {
        Write-Host "Success, you are connected" -ForegroundColor Green
    }
    else {
        Write-Host "BOOOOO" -ForegroundColor Red
    }
}
catch {
    Write-Host "Check the wi-fi connection" -ForegroundColor Red
}
Write-Output "**Done**"
