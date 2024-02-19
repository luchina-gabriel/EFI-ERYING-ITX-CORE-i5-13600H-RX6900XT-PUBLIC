@echo off
set substring_1=ThunderboltControlCenter
set substring_2=PackageFullName
set "File2Read=allPackeges.txt"

setlocal EnableExtensions EnableDelayedExpansion
for /f "delims=" %%a in ('Type "%File2Read%"') do (
    set /a count+=1
    set "Line[!count!]=%%a"
)
For /L %%i in (1,1,%Count%) do (
	echo "!Line[%%i]!" | findstr /C:"!substring_1!" | findstr /C:"!substring_2!" 1>nul
	set /a index+=1
	if errorlevel 1 (
		rem pattern not found
	) ELSE (
		rem got zero found pattern
		for /F "tokens=2 delims=:" %%a in ("!Line[%%i]!") do (
		set appName=%%a
)
		powerShell.exe Set-ExecutionPolicy RemoteSigned
		powerShell.exe -File .\InstallScripts\appxUninstaller.ps1 !appName!
		IF ERRORLEVEL 1 GOTO ERROR
		goto :EXIT
	)
)

:EXIT
exit /b 0

:ERROR 
ECHO Uninstall failed, refer to TBT_Uninstall.log.
echo   The file "%File2Read%" does not exist ! >> %logFile%
exit /b 1