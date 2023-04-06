@echo off

set PCM_TOOL_PATH=%SYSTEMDRIVE%%HOMEPATH%\Desktop\HP_PCM_Tool_v1.0.5
set PERF_LOG_PATH=%SYSTEMDRIVE%\data\asmt\results


:: COPY HP PCM TOOL LOGS FOLDER
xcopy /E /Q /I "%PCM_TOOL_PATH%\LOGS" %~dp0\logs\LOGS


:: COPY HP PCM TOOl XLSX FILE
xcopy /Q /I %PCM_TOOL_PATH%\*.xlsx %~dp0\logs
if exist %~dp0\logs\PCM_report_template_*.xlsx del %~dp0\logs\PCM_report_template_*.xlsx


:: COPY SYSTEM POWER REPORT
powercfg /sleepstudy 
if exist sleepstudy-report.html move sleepstudy-report.html %~dp0\logs


:: COPY PERFORMANCE LOG & CAPTURE SCREENSHOT OF XML FILE
for /f %%i in ('dir /b /ad /od %PERF_LOG_PATH%') do set LATEST_FOLDER=%%i
xcopy /E /Q /I %PERF_LOG_PATH%\%LATEST_FOLDER% %~dp0\logs\%LATEST_FOLDER%
start /max %~dp0\data\wac.exe %~dp0\logs\%LATEST_FOLDER%\%LATEST_FOLDER%.xml
start %~dp0\data\nircmd.exe cmdwait 3000 savescreenshot "%~dp0\logs\Results.png"
timeout 5 > NUL
taskkill /f /im wac.exe > NUL


:: ZIP PERFORMANCE LOG
%~dp0\data\7z.exe a -sdel %~dp0\logs\%LATEST_FOLDER%.zip %~dp0\logs\%LATEST_FOLDER% 


pause