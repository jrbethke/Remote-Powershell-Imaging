# Description: Enable Remote Powershell on Windows 10
# Setting network sharing and firewall rules to enable remote PowerShell
Get-NetConnectionProfile
Set-NetConnectionProfile -Name "wi-fi" -NetworkCategory Private
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes

# Enable remote PowerShell
Enable-PSRemoting

# Check if the WinRM service is running
winrm enumerate winrm/config/listener

# Check if the WinRM service is listening on port 5985
netstat -ano | Select-String 5985 