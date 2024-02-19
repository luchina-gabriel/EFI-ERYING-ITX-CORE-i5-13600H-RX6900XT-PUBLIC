try{
	$ErrorActionPreference = "Stop"; #Make all errors terminating
	$ScriptPath = (Get-Variable MyInvocation).Value.MyCommand.Path
	$ScriptDir = Split-Path -Parent $ScriptPath
	if (Test-Path -Path $ScriptDir\TMP_FILEVER_DIR ) {
		Remove-Item $ScriptDir\TMP_FILEVER_DIR -Force -Recurse | Out-Null
	}	
	if (!(Test-Path $env:windir\System32\Drivers\TbtBusDrv.sys -PathType Leaf)) {
		write-host "No previous driver, new driver can be installed."
		exit 0
	}
	New-Item $ScriptDir\TMP_FILEVER_DIR -Type Directory | Out-Null
	write-host "There is a previous driver, comparing versions."
	Copy-Item $env:windir\System32\Drivers\TbtBusDrv.sys -Destination $ScriptDir\TMP_FILEVER_DIR	
	[version]$InstalledDrvVer=(gi $ScriptDir\TMP_FILEVER_DIR\TbtBusDrv.sys).versioninfo.FileVersion
	[version]$InstallationDrvVer=(gi $ScriptDir\..\Drivers\ThunderboltWindowsDchSetup\TbtBusDrv.sys).versioninfo.FileVersion
	write-host "Installed driver version = $InstalledDrvVer"
	write-host "Installation driver version = $InstallationDrvVer"
	Remove-Item $ScriptDir\TMP_FILEVER_DIR -Force -Recurse | Out-Null
	if($InstallationDrvVer -gt $InstalledDrvVer) {
		write-host "Installation driver version is higher than installed driver version, installation will proceed."
		exit 1
	}
	if ($InstallationDrvVer -eq $InstalledDrvVer) {
		write-host "Installation driver version equals to installed driver version, driver installation will be skipped."
		exit 2
	} else {
		write-host "Installed driver version is higher than Installation driver version. Driver installation will be skipped."
		exit 3
	}
} catch {
write-host "exception thrown in detectPrevDrv.ps1"
exit 4
}


