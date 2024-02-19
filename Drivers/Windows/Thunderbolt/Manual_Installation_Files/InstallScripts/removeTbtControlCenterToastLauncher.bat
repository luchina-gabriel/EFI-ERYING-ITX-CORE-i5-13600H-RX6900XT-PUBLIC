@echo off

if exist "C:\windows\TbtControlCenterToastLauncher.exe" (
	del C:\windows\TbtControlCenterToastLauncher.exe
	echo "removed TbtControlCenterToastLauncher.exe succeed."
) else (
	echo "TbtControlCenterToastLauncher.exe not found, skipping removal."
)

:EXIT
exit /b 0

