@echo off

if exist "C:\windows\system32\TbtAppLauncherComServer.exe" (
	C:\windows\system32\TbtAppLauncherComServer.exe /unregserver
	if errorlevel 1 (
			echo "Failed to unregister TbtAppLauncherComServer."
			goto :ERROR
	) ELSE (
			rem remove file TbtAppLauncherComServer.exe
			del C:\Windows\System32\TbtAppLauncherComServer.exe
			echo "Unregister TbtAppLauncherComServer succeed."
	)
)

:EXIT
exit /b 0

:ERROR
exit /b 1
