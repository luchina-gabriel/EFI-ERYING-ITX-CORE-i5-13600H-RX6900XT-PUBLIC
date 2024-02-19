@echo off
set logFile=%~dp0\TBT_Install.log

call .\InstallScripts\runDetectPrvDrv.bat > %logFile%
IF %ERRORLEVEL%==0 ( 
	rem No previous driver, new driver can be installed.
	echo Installation in progress...
	GOTO INSTALL_DRIVERS
) ELSE IF %ERRORLEVEL%==1 (
	rem Installation driver version is greater than installed driver version, installation will proceed.
	echo Upgrade will be performed following previous version uninstall.
	echo Uninstall previous version. >> %logFile%
	call Uninstall.bat >> %logFile%
	GOTO INSTALL_DRIVERS
) ELSE IF %ERRORLEVEL%==2 (
	rem Installation driver version equals to installed driver version, driver installation will be skipped.
	ECHO Thunderbolt driver already installed on host.
	GOTO HSA
) ELSE IF %ERRORLEVEL%==3 (
	rem Installed driver version is greater than Installation driver version. Driver installation will be skipped.
	ECHO A newer version of Thunderbolt driver already installed on host.
	GOTO HSA
) ELSE IF %ERRORLEVEL%==4 (
	ECHO An exception was thrown in detectPrvDrv.ps1. >> %logFile%
	ECHO Installation fail. unable to detect previous installed version.
	GOTO HSA
)


:INSTALL_DRIVERS
pnputil -i -a .\Drivers\ThunderboltWindowsDchSetup\TbtHostController.inf >> %logFile%	
IF ERRORLEVEL 1 GOTO ERROR
pnputil -i -a .\Drivers\ThunderboltApplicationLauncherSetup\TbtHostControllerExtension.inf >> %logFile%
IF ERRORLEVEL 1 GOTO ERROR
	
:HSA
IF "%1" == "appInstall" (
	call .\InstallScripts\InstallAppCtrl.bat >> %logFile%
	IF ERRORLEVEL 1 GOTO ERROR
) ELSE (
	ECHO Skipping app ctrl install. >> %logFile%
)

:EXIT
ECHO Thunderbolt installation finished successfully. >> %logFile%
ECHO Thunderbolt installation finished successfully.
exit /b 0

:ERROR 
ECHO Installation failed >> %logFile%
ECHO Installation failed, refer to %logFile%.
exit /b 1