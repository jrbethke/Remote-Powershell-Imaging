@echo off
setlocal enabledelayedexpansion

:: Find the drive letter of "New_Volume"
for /f "tokens=2 delims==" %%D in ('wmic logicaldisk where "VolumeName='New_Volume'" get DeviceID /value 2^>nul') do (
    set "USB_DRIVE=%%D"
)

:: Check if USB drive was found
if not defined USB_DRIVE (
    echo USB drive labeled "New_Volume" not found!
    pause
    exit /b
)

:: Set source and destination for "local-Imager" folder
set "SOURCE_FOLDER=%USB_DRIVE%\local-Imager"
set "DEST_FOLDER=%USERPROFILE%\Desktop\local-Imager"

:: Copy "Imager" folder to desktop
xcopy "%SOURCE_FOLDER%" "%DEST_FOLDER%" /E /I /Y
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to copy local-Imager folder!
    pause
    exit /b
)

:: Set source and destination for "software" folder
set "SOURCE_FOLDER=%USB_DRIVE%\software"
set "DEST_FOLDER=%USERPROFILE%\Desktop\software"

:: Copy "software" folder to desktop
xcopy "%SOURCE_FOLDER%" "%DEST_FOLDER%" /E /I /Y
if %ERRORLEVEL% neq 0 (
    echo Error: Failed to copy software folder!
    pause
    exit /b
)

echo Copy completed successfully!
pause
