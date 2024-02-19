@echo off

if exist "C:\\Windows\\System32\\drivers\\TbtBusDrv.sys"  (
	echo "Removing Thunderbolt(TM) Bus driver sys file..."
	rem ATTRIB -S C:\\Windows\\System32\\drivers\\TbtBusDrv.sys
	del C:\Windows\System32\drivers\TbtBusDrv.sys
) else (
	echo TbtBusDrv.sys not found
)
if exist "C:\\Windows\\System32\\drivers\\TbtP2pNdisDrv.sys"  (
	echo "Removing Thunderbolt(TM) P2P Ndis driver sys file..."
	del "C:\Windows\System32\drivers\TbtP2pNdisDrv.sys"
) else (
	echo TbtP2pNdisDrv.sys not found
)
if exist "C:\Windows\System32\ThunderboltService.exe"  (
	echo "Removing Thunderbolt(TM) Service..."
	del "C:\Windows\System32\ThunderboltService.exe"
) else (
	echo ThunderboltService.exe not found
)

exit /b 0