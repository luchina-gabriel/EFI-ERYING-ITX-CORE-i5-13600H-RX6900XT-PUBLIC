@echo off
Setlocal enabledelayedexpansion
cls

CD /D %~dp0

rem This batch file will append data to the log on every reboot.
rem Note that running this batch file without running StopBootTrace.bat eventually will
rem make the tbtLog.etl too large to analyze and may eventually fill the hard drive.
rem run StopBootTrace.bat in order to stop logging after boot (once you do that, tbtLog.etl will appear)

set SCRIPTS_DIR="%cd%"

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

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-3 delims=/:" %%a in ("%TIME%") do (set mytime=%%a-%%b-%%c)

set SUFFIX_STRING=%1%
set SUFFIX_STRING=%SUFFIX_STRING: =_%

set ARGC=0
for %%x in (%*) do Set /A ARGC+=1

if not %ARGC%==0 set SUFFIX=_%SUFFIX_STRING%

set TRACE_DIR="TBT_CONT_BOOT_LOG_%mydate%_%mytime%%SUFFIX%"
set "TRACE_DIR=%TRACE_DIR: =%"

if not exist %TRACE_DIR% mkdir %TRACE_DIR%
pushd %TRACE_DIR%
	set CURRENT_TRACE_DIR="%cd%"
popd

call %SCRIPTS_DIR%\CollectEnvironmentInfo.bat %CURRENT_TRACE_DIR% %SCRIPTS_DIR%

logman create trace autosession\TbtBootLogSession -o %CURRENT_TRACE_DIR%\TbtLog.etl -ets -pf wpp.guids -a

echo Don't forget to call StopBootTrace after the reboot (or the trace will continue running every boot).
echo This trace will append data on every boot to the same log

pause
