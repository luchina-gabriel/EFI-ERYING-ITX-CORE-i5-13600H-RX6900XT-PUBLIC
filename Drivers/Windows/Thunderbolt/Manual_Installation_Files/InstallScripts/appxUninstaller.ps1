param(
[string]$a
)
try{
$ErrorActionPreference = "Stop"; #Make all errors terminating
#Start-Transcript -Path TBT_Uninstall.log -force -Append
Remove-AppxPackage -Package $a -AllUsers
#Stop-Transcript
} catch {
exit 1
}
exit 0