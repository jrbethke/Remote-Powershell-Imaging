@echo off
REM Get the current drive where the batch file is running
set SCRIPT_PATH="C:\Users\user\Desktop\local-Imager\Remote-Driver.ps1"
:: if you are using a different path, make sure to change the path to the correct one

REM Launch the script with the execution policy set to RemoteSigned
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File %SCRIPT_PATH%