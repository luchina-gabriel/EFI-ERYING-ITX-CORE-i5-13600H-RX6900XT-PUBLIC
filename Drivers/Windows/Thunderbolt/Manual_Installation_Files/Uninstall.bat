@echo off

set logFile=%~dp0\TBT_Uninstall.log

echo This may take a few minutes...

REM remove previous log file
del %logFile% 2>NUL

rem uninstall TBT control application (appx)
SET ThisScriptsDirectory=%~dp0
SET PowerShellScriptPath=%ThisScriptsDirectory%\InstallScripts\appxDetect.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%'" >> %logFile% 2>&1
call .\InstallScripts\detectTBTAppName.bat
IF ERRORLEVEL 1 GOTO ERROR

rem remove devices
call .\InstallScripts\removeDevices.bat >> %logFile% 2>&1
IF ERRORLEVEL 1 GOTO ERROR

rem Uninstalling oem.inf files
call .\InstallScripts\removeOemFiles.bat >> %logFile% 2>&1
IF ERRORLEVEL 1 GOTO ERROR

rem Removing Thunderbolt(TM) Application Launcher service
call .\InstallScripts\removeLauncherService.bat >> %logFile% 2>&1
IF ERRORLEVEL 1 GOTO ERROR

rem Removing TbtControlCenterToastLauncher.exe
call .\InstallScripts\removeTbtControlCenterToastLauncher.bat >> %logFile% 2>&1
IF ERRORLEVEL 1 GOTO ERROR

rem Removing TBT sys file(s)
call .\InstallScripts\removeTBTsysFiles.bat >> %logFile% 2>&1
IF ERRORLEVEL 1 GOTO ERROR

rem Removing TbtAppLauncherComServer
call .\InstallScripts\removeTBTCOMServer.bat >> %logFile% 2>&1
IF ERRORLEVEL 1 GOTO ERROR

devcon rescan >> %logFile% 2>&1
:EXIT
rem remove all temporary files
del services.txt 2>NUL
del devices.txt 2>NUL
del drivers.txt 2>NUL
del allPackeges.txt 2>NUL
ECHO Thunderbolt uninstall finished successfully.
exit /b 0

:ERROR 
del services.txt 2>NUL
del devices.txt 2>NUL
del drivers.txt 2>NUL
del allPackeges.txt 2>NUL
ECHO Uninstall failed, refer to %logFile%.
exit /b 1