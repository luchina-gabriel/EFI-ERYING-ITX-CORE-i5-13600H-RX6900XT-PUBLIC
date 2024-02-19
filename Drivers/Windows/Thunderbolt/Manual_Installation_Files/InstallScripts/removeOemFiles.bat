@echo off

rem Setting all UWD inf names
set substring_1=tbthostcontrollerextension.inf
set substring_2=tbthostcontroller.inf
set substring_3=tbthostcontrollerhsacomponent.inf
set substring_4=tbtp2pndisdrv.inf
set substring_5=tbthostcontrollertoastcomponent.inf

set counter1=0
set counter2=0
set counter3=0
set counter4=0
set counter5=0

set prev_line=""

pnputil /enum-drivers > drivers.txt

set "File2Read=drivers.txt"
If Not Exist "%File2Read%" (Goto :Error)

rem This will read a file into an array of variables and populate it 
setlocal EnableExtensions EnableDelayedExpansion
for /f "delims=" %%a in ('Type "%File2Read%"') do (
    set /a count+=1
    set "Line[!count!]=%%a"
)
For /L %%i in (1,1,%Count%) do (
	echo "!Line[%%i]!" | findstr /C:"!substring_1!" 1>nul
	if errorlevel 1 (
		rem pattern not found
		rem echo "did not find "!substring_1!" in !Line[%%i]!"
	) ELSE (
		rem got zero found pattern
		call :getOemNum "!Line[%%i]!" "!prev_line!"
		set /a counter1+=1
	)
	
	echo "!Line[%%i]!" | findstr /C:"!substring_2!" 1>nul
	if errorlevel 1 (
		rem pattern not found
		rem echo "did not find "!substring_1!" in !Line[%%i]!"
	) ELSE (
		rem got zero found pattern
		call :getOemNum "!Line[%%i]!" "!prev_line!"
		set /a counter2+=1
	)
	
	echo "!Line[%%i]!" | findstr /C:"!substring_3!" 1>nul
	if errorlevel 1 (
		rem pattern not found
		rem echo "did not find "!substring_1!" in !Line[%%i]!"
	) ELSE (
		rem got zero found pattern
		call :getOemNum "!Line[%%i]!" "!prev_line!"
		set /a counter3+=1
	)
	
	echo "!Line[%%i]!" | findstr /C:"!substring_4!" 1>nul
	if errorlevel 1 (
		rem pattern not found
		rem echo "did not find "!substring_1!" in !Line[%%i]!"
	) ELSE (
		rem got zero found pattern
		call :getOemNum "!Line[%%i]!" "!prev_line!"
		set /a counter4+=1
	)
	echo "!Line[%%i]!" | findstr /C:"!substring_5!" 1>nul
	if errorlevel 1 (
		rem pattern not found
		rem echo "did not find "!substring_1!" in !Line[%%i]!"
	) ELSE (
		rem got zero found pattern
		call :getOemNum "!Line[%%i]!" "!prev_line!"
		set /a counter5+=1
	)

	set "prev_line=!Line[%%i]!"
)

echo "%substring_1% found and removed: %counter1% times"
echo "%substring_2% found and removed: %counter2% times"
echo "%substring_3% found and removed: %counter3% times"
echo "%substring_4% found and removed: %counter4% times"
echo "%substring_5% found and removed: %counter5% times"

exit /b 0

:getOemNum
rem echo "proccesing %1, searching for %~2"
for /F "tokens=2 delims=:" %%a in ("%~2%") do ( 
   call :deleteOEM %%a
)
exit /b

:deleteOEM
set strDelete="remove %1"
echo %strDelete%
pnputil /delete-driver %1 /force /uninstall
exit /b

:ERROR 
ECHO Uninstall failed, refer to logFile.
echo   The file "%File2Read%" does not exist !
exit /b 1