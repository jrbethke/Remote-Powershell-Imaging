# Remote Powershell Imaging
 Set up powershell session to modify multiple computers at once. This setup utilizes a USB device named "New_Volume" to transfer over files and other items to 
 set up computers. There will be several items to setup prior to running the script.

## Set up your USB

On the USB drive, copy the following items:

- `tech_account_create.bat`
- `local-Imager` (folder)
- `copy_local_imager_software`
- `software` (folder)

**Note:**  
- The `software` folder contains software for downloading from remote PowerShell sessions after the computer has been renamed.
- Make sure any software that can be installed before renaming the computer is located in the `local-Imager/Installs` folder.


## Your Personal Computer

Take note of the path where these items are placed. You will need the path for running scripts later.

Needed items are:

- `Remote-Scripts` (folder)
- `Remote-Imager.ps1`


## Editing PS1 Files on USB

Several files will need to be modified before the script is run. Later versions will reduce this necessity.

The following items are in the `local-Imager` folder:

- `Start_Remote_Driver.bat`: Make sure the script path matches the intended path. The username `C:\Users\<Username>` is preset and needs to be modified.
- `Remote-Powershell-Enable`: Change the name of the connection to match your network connection.
  ```powershell
  Set-NetConnectionProfile -Name "wi-fi" -NetworkCategory Private

- This also applies to `copy_local_imager_software` for pathing.

- `tech_account_create.bat`: Edit this file if you need to create a different user. **Note**: This batch file must be run as administrator.

- `Domain-Join.ps1`: Modify the domain name, server IP address, and computer name parameters to be set to the desired values.


## Setup on Remote Device

- If you are on the intended user device, copy the `local-Imager` and `software` folders onto the desktop using the `copy_local_imager_software` batch file.  
  **Note**: This does not require running as administrator.

- If the scripts and batch files were modified correctly, run `Start_Remote_Driver` as an administrator and wait for the task to be completed.

- Restart the computer when done and sign in with a local user.  
  **Note**: If the computer is domain-joined, it must be a domain administrator.

- Once the script is started and if your remote support software installer was included, you can connect shortly after starting the script.


## Running Scripts from Your Computer

- Launch a terminal window with admin privileges and navigate to where the scripts and folders were copied to.

- Run a similar command with your own values to start the imaging process:

```powershell
.\Remote-Imager.ps1 -site "Company" -pctype "PC" -start 1 -end 5 -user "Domain\admin"







