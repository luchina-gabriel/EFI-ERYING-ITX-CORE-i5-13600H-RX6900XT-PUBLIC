@echo off
Setlocal enabledelayedexpansion
cls

set SCRIPTS_DIR="%cd%"

For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-3 delims=/:" %%a in ("%TIME%") do (set mytime=%%a-%%b-%%c)

set SUFFIX_STRING=%1%
set SUFFIX_STRING=%SUFFIX_STRING: =_%

set ARGC=0
for %%x in (%*) do Set /A ARGC+=1

if not %ARGC%==0 set SUFFIX=_%SUFFIX_STRING%

set TRACE_DIR="TBT_LOG_%mydate%_%mytime%%SUFFIX%"
set "TRACE_DIR=%TRACE_DIR: =%"

if not exist %TRACE_DIR% mkdir %TRACE_DIR%

pushd %TRACE_DIR%
	set CURRENT_TRACE_DIR="%cd%"
popd

call %SCRIPTS_DIR%\CollectEnvironmentInfo.bat %CURRENT_TRACE_DIR% %SCRIPTS_DIR%

logman start TbtLogSession -o %CURRENT_TRACE_DIR%\tbtLog.etl -ets -pf wpp.guids

rem DumpDriverInfo must be called after trace has started.
call DumpDriverInfo.bat %CURRENT_TRACE_DIR%

