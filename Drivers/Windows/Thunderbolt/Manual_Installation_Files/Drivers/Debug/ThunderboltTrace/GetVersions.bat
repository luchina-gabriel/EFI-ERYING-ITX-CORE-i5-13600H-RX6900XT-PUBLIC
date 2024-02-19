@echo off
setlocal

set CURRENT_TRACE_DIR=%1
set SCRIPTS_DIR=%2%

if not exist %CURRENT_TRACE_DIR% goto end

pushd %CURRENT_TRACE_DIR%
mkdir TMP_FILEVER_DIR
popd

pushd %SystemRoot%\System32\Drivers
for %%f in (Tbt*.sys) do (
	copy %%f %CURRENT_TRACE_DIR%\TMP_FILEVER_DIR
)
popd

pushd %SystemRoot%\System32
for %%f in (Tbt*.exe) do (
	copy %%f %CURRENT_TRACE_DIR%\TMP_FILEVER_DIR
)

for %%f in (Thunderbolt*.exe) do (
	copy %%f %CURRENT_TRACE_DIR%\TMP_FILEVER_DIR
)
popd

pushd %CURRENT_TRACE_DIR%
pushd TMP_FILEVER_DIR
for %%f in (*.*) do (
call %SCRIPTS_DIR%\filever.exe -v %%f >> ..\%%f.info.txt
)
popd
rmdir /Q /S TMP_FILEVER_DIR
popd


:end
