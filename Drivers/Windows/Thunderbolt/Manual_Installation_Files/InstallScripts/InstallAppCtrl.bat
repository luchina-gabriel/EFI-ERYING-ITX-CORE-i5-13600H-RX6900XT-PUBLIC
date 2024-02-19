@echo off

ECHO Installing app ctrl.
SET ThisScriptsDirectory=%~dp0
SET PowerShellScriptPath=%ThisScriptsDirectory%appxInstaller.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%PowerShellScriptPath%'";
IF ERRORLEVEL 1 GOTO ERROR

:EXIT
exit /b 0

:ERROR 
exit /b 1