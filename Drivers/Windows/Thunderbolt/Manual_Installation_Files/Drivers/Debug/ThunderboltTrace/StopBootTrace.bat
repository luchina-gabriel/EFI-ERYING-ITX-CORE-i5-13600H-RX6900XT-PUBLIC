@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

:: Check for Mandatory Label\High Mandatory Level
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( 
echo got admin
goto gotAdmin 
)

:UACPrompt
	echo prompting
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "%~s0", "%params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin

CD /D %~dp0

call DumpDriverInfo.bat "%cd%" end_boot_

logman stop TbtBootLogSession -ets
logman delete autosession\TbtBootLogSession -ets -fd
