@echo off

rem DumpDriverInfo must be called before trace is stopped.
call DumpDriverInfo.bat %TRACE_DIR% end_
logman stop TbtLogSession -ets
