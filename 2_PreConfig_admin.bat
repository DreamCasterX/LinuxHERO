@echo off


:: DISABLE ADAPTIVE BRIGHTNESS
powercfg -setacvalueindex SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 FBD9AA66-9553-4097-BA44-ED6E9D65EAB8 0
powercfg -setdcvalueindex SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 FBD9AA66-9553-4097-BA44-ED6E9D65EAB8 0
powercfg -SetActive SCHEME_CURRENT


:: SET BRIGHTNESS LEVEL
set /p BRIGHTNESS=Enter brightness level conforming to 150 nits (0~100): 
cls
powershell -command "(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,%BRIGHTNESS%)" > NUL
echo (1) Brightness level is set to %BRIGHTNESS%%%
echo.


:: SET VOLUME TO 50%
powershell -command "Function Set-Speaker($Volume){$wshShell = new-object -com wscript.shell;1..50 | %% {$wshShell.SendKeys([char]174)};1..$Volume | %% {$wshShell.SendKeys([char]175)}}" ; Set-Speaker -Volume 25"
echo (2) Volume is set to 50%%
echo.


:: SET TIME ZONE
tzutil /s "Taipei Standard Time"
:: w32tm /resync > NUL
echo (3) Time zone is set to UTC+8
echo.


:: DOWNLOAD MS TEAMS (FOR WORK OR SCHOOL)
if exist "%SYSTEMDRIVE%%HOMEPATH%\AppData\Local\Microsoft\Teams\current\Teams.exe" (
    echo ^(4^) MS Teams is installed) & goto NEXT
if not exist "%SYSTEMDRIVE%%HOMEPATH%\Desktop\TeamsSetup_c_w_.exe" (
    powershell -command "Invoke-WebRequest https://tinyurl.com/nhcyn4ay" -OutFile "%SYSTEMDRIVE%%HOMEPATH%\Desktop\TeamsSetup_c_w_.exe" > NUL)
if %errorlevel% neq 0 (echo Failed to download MS Teams!! Check your network connection) & goto STARTOVER
echo ^(4^) MS Teams is downloaded
:NEXT
echo.


:: OUTPUT BITLOCKER RECOVERY KEY
manage-bde -protectors -get C: > NUL
if %errorlevel%==0 (
    manage-bde -protectors -get C: > %~dp0\Bitlocker.txt & echo ^(5^) Bitlocker recovery key is saved
) else (
    echo ^(5^) Bitlocker is not enabled on this system - skip output)


:: CHECK TEST SIGNING
bcdedit > BCD.txt
powershell cat BCD.txt ^| findstr "testsigning" ^| findstr "Yes" > NUL
if %errorlevel%==0 goto EOF 
if exist BCD.txt del BCD.txt


:: CHECK SECURE BOOT & ENABLE TEST SIGNING
echo.
for /f %%i in ('powershell Confirm-SecureBootUEFI') do set SB_STATE=%%i
if %SB_STATE% equ False (
    echo Enabing test signing now.... 
    bcdedit /set testsigning on > NUL
    shutdown /r /t 5 & goto STARTOVER
) else (
    echo Secure boot is NOT disabled!! Enter BIOS to disable Secure boot first) & goto STARTOVER
:EOF
echo.
echo (6) Test signing is enabled
:STARTOVER
if exist BCD.txt del BCD.txt
echo.
echo.
echo.
echo.
pause
