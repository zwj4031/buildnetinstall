@echo off
wpeinit
@echo renew netcard......
ipconfig /renew >nul
@echo ok.
@echo disablefirewall……
wpeutil disablefirewall
MODE CON COLS=56 LINES=10
cd /d X:\windows\system32

	set arch=x64
if %PROCESSOR_ARCHITECTURE% == x86 (
	set arch=x86
  )
copy 7z%arch%.dll %cd%\7z.dll /y
echo extracting files ...
%cd%\7z%arch%.exe x tool.7z -o%cd%\ -y
copy /y %cd%\%arch%.wcs %cd%\tool.wcs 
copy /y %cd%\pecmd%arch%.exe %cd%\pecmd.exe
copy /y %cd%\cgi%arch%.exe %cd%\cgi.exe
::copy pecmd%arch%.exe %cd%\pecmd.exe /y
::%cd%\pecmd %arch%.wcs
for %%i in (name installiso setupiso httptimeout command serverip checkwim p2p formatmbr formatgpt) do (
for /f "tokens=1,2 delims==" %%a in ('find "%%i=" null.cfg') do set %%i=%%b
)
)
set isopath=%installiso%

echo name=%name%
echo installiso=%installiso%
echo setupiso=%setupiso% 
echo httptimeout=%httptimeout% 
echo command=%command%
echo serverip=%serverip%
echo checkwim=%checkwim%
echo p2p=%p2p%
echo formatmbr=%formatmbr%
echo formatgpt=%formatgpt%

:判断p2p值
if defined p2p (
    goto startp2p
) else set p2p=""

::%~dp0\7z%arch% x xfscient.7z -o%~dp0\ -y

echo ok..

::net stop "Fanxiushu File System Redirect Directory"
sc create xFsRedirApp binpath= "%~dp0\xFsRedir%arch%.exe -server" displayname= "Fanxiushu File System Redirect Directory" start= auto
::sc create xfs_redir binpath= "%~dp0\xfs_redir.sys" displayname= "xfs_redir" start= auto
echo []>%~dp0\xFsRedir.ini
cls
echo building config....
setlocal enabledelayedexpansion
(
echo [vdisk0]
echo disable=0
echo drive_letter=Q
echo disk_size=64
echo disk_type=1
echo is_cdrom=1
echo is_read_only=1
echo image_url=%isopath%
echo user=
echo pwd=
echo nfs_mountdir=
:::下面的是线程数
echo threadcount=55
echo transtimeout=60
)>>%~dp0\xFsRedir.ini
ping 127.0 -n 2 >nul
net start "Fanxiushu File System Redirect Directory"

set xml=
if exist autounattend.xml (
  set xml=/Unattend:%~dp0\autounattend.xml
  echo Add parameter %xml%
)
cls

:判断httptimeout值
if defined httptimeout (
    echo %httptimeout%
) else set httptimeout=

:判断command值
if defined command (
    echo %command%
) else set command=Q:\setup.exe


:判断checkwim值
if defined checkwim (
    echo %checkwim%
) else set checkwim=I:\ghos\system.wim


:setupwin
echo wait.................
ipconfig
echo installiso=%isopath%
echo httptimeout=%httptimeout%
ping 127.0 -n %httptimeout% >nul
if exist Q:\setup.exe Q:\setup.exe %xml%
if not exist Q:\setup.exe goto try

:try
net stop "Fanxiushu File System Redirect Directory"
net start "Fanxiushu File System Redirect Directory"
echo try again........
ipconfig
echo installiso=%isopath%
echo httptimeout=%httptimeout%
ping 127.0 -n 20 >nul
if exist Q:\setup.exe %command% %xml%
if not exist Q:\setup.exe cmd /k
exit
:::::::::::::::::::::::::::::以下是p2p
:startp2p
cls
:判断formatmbr值
if defined formatmbr (
    aria2c http://%serverip%/app/winsetup/format.bat.mbr -d X:\ >nul
	if exist X:\format.bat del /q X:\format.bat
	ren X:\format.bat.mbr format.bat
	call X:\format.bat
) else set formatmbr=""
:判断formatgpt值
if defined formatgpt (
    aria2c http://%serverip%/app/winsetup/format.bat.gpt -d X:\ >nul
	if exist X:\format.bat del /q X:\format.bat
	ren X:\format.bat.gpt format.bat
	call X:\format.bat
) else set formatgpt=""

ipconfig
echo installiso:%isopath%
echo httptimeout:%httptimeout%
echo formatmbr: %formatmbr%
echo formatgpt: %formatgpt%
echo warning!! p2pmode!!!
ping 127.0 -n %httptimeout% >nul
if exist X:\winp2p.exe del /q X:\winp2p.exe
aria2c http://%serverip%/app/winsetup/winp2p.exe -d X:\ >nul
start "" /min cmd /c X:\winp2p.exe
:startcheck
if not exist %checkwim% (
echo 正在同步…… 
ping 127.0 -n 6 >nul
) else (
echo 同步完成，准备还原…… &&goto cgi
)
:end
goto startcheck
:cgi
ping 127.0 -n %httptimeout% >nul
(
echo [operation]
echo action=restore
echo silent=1
echo [source]
echo %checkwim%^|1
echo [destination]
echo DriveLetter = system
echo [miscellaneous]
echo format = 1
echo fixboot=auto
echo shutdown=2
)>"%temp%\system.ini"
start "" "X:\windows\system32\cgi.exe" %temp%\system.ini
exit


::echo list volume|diskpart|findstr /i Document >~tmp
::for /f "tokens=2" %%a in (~tmp) do set part=%%a
::cmd /c "echo sele disk 0 & echo sele part %part% & echo set id=12" | diskpart
::del ~tmp
::echo 找到盘 %part%




