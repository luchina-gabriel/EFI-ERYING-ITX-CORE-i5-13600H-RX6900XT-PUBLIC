@echo off

set "baseSysDev=Base System Device"
set "TBTCtrl=Thunderbolt(TM) Controller"
setlocal EnableExtensions EnableDelayedExpansion

devcon rescan
devcon find "PCI\VEN_8086&DEV_*" > devices.txt
set "DevicesFile=devices.txt"
for /f "delims=" %%a in ('Type "%DevicesFile%"') do (
    set /a count+=1
    set "Line[!count!]=%%a"
)
rem create Thunderbolt device id's array
set "TbtDevicesFile=.\InstallScripts\ThunderboltDeviceIds.txt"
for /f "delims=" %%a in ('Type "%TbtDevicesFile%"') do (
    set /a tbt_ids_count+=1
    set "Tbt_ids_arr[!tbt_ids_count!]=%%a"
)

For /L %%i in (1,1,%Count%) do (
	echo "!Line[%%i]!" | findstr /C:"!baseSysDev!" 1>nul
	if errorlevel 1 (
	rem pattern not found --> device is not base system device. check if it is Thunderbolt...
	rem go over each one of the TBT device ids to make the check
	For /L %%j in (1,1,%tbt_ids_count%) do (
		echo "!Line[%%i]!" | findstr /C:"!Tbt_ids_arr[%%j]!" 1>nul
		if errorlevel 1 (
			rem pattern not found
		) ELSE (
		rem got zero found pattern
		echo "Thunderbolt(TM) Controller found, removing it..."
		set deviceName="@!Tbt_ids_arr[%%j]!*"
		devcon /r remove "!deviceName!"
		)
		)
	) ELSE (
		rem got zero found pattern
		echo "Base System Device found, proceeding..."
	)
	
)

:EXIT
exit /b 0
