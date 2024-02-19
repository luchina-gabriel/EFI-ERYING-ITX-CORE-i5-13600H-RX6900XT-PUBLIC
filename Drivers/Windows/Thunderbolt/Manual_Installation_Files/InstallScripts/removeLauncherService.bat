@echo off

echo Searching for Thunderbolt(TM) Application Launcher service...
set tbt_service=TbtHostControllerService
set /a flag=0
sc query > services.txt
set "File2Read=services.txt"

setlocal EnableExtensions EnableDelayedExpansion
for /f "delims=" %%a in ('Type "%File2Read%"') do (
    set /a count+=1
    set "Line[!count!]=%%a"
)
For /L %%i in (1,1,%count%) do (
	echo "!Line[%%i]!" | findstr /C:"!tbt_service!" 1>nul
	if errorlevel 1 (
		rem pattern not found
	) else (
		echo "Thunderbolt(TM) Application Launcher service found. Stopping it..."
		SC stop TbtHostControllerService
		rem echo "%errorlevel%"
		rem if errorlevel 1 (
		rem	echo "Access denied. Run this script as Administrator"
		rem	exit /b 1
		rem ) else (
			echo "Thunderbolt(TM) Application Launcher service stopped. removing it..."
			rem service stopped --> remove it.
			SC delete %tbt_service%
			if errorlevel 1 (
				echo "Failed to remove Thunderbolt(TM) Application Launcher service"
			) else (
				set /a flag=1
				echo "Thunderbolt(TM) Application Launcher service removed successfully"
			)
		rem )
	)
)

if exist "c:\windows\ThunderboltService.exe" (
	del "c:\windows\ThunderboltService.exe"
	echo "Removed ThunderboltService.exe from c:\windows."
)

exit /b 0


