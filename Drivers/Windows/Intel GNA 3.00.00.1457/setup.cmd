@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)
%~d0
cd %~dp0
start /w pnputil.exe /add-driver *.inf /subdirs /install

;%~d0
;cd %~dp0
;%windir%/system32/pnputil /add-driver *.inf /subdirs /install

timeout /t 5
exit
