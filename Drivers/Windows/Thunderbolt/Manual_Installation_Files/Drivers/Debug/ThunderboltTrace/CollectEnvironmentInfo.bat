@echo off

setlocal

set CURRENT_TRACE_DIR=%1
set SCRIPTS_DIR=%2%

if exist "..\ThunderboltParseTrace" copy ..\ThunderboltParseTrace\*.* /y %CURRENT_TRACE_DIR%

if exist "..\PrivateSymbolsStore" (
	copy ..\PrivateSymbolsStore\*.* /y %CURRENT_TRACE_DIR%
) else if exist "..\ThunderboltDriversPackage\SymbolsStore" (
	copy ..\ThunderboltDriversPackage\SymbolsStore\*.* /y %CURRENT_TRACE_DIR%
)

if exist "..\KmglDriversPackage\SymbolsStore" (
	copy ..\KmglDriversPackage\SymbolsStore\*.* /y %CURRENT_TRACE_DIR%
)

if exist "..\CentralScrutinizerPackage\SymbolsStore" (
	copy ..\CentralScrutinizerPackage\SymbolsStore\*.* /y %CURRENT_TRACE_DIR%
)

call %SCRIPTS_DIR%\GetVersions.bat %CURRENT_TRACE_DIR% %SCRIPTS_DIR%