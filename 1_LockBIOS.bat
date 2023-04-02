@echo off

:: LOCK BIOS CHECK
echo English>LockBIOS.txt
echo Lock BIOS Version>>LockBIOS.txt
echo 	Disable>>LockBIOS.txt
echo		*Enable>>LockBIOS.txt
%~dp0/data/BiosConfigUtility.exe /setconfig:"%~dp0/LockBIOS.txt"
if %errorlevel% == 0 (
    echo BCU is written successfully. Reboot the system to take effect
) else (
    echo Please run the script WITHOUT administrator privileges) 
if exist LockBIOS.txt del LockBIOS.txt

echo.
pause