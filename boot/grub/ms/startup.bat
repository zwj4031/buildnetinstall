@echo off
wpeinit
@echo renew netcard......
ipconfig /renew >nul
@echo ok.
@echo disablefirewall……
wpeutil disablefirewall
MODE CON COLS=56 LINES=10
cd /d X:\windows\system32
set root=X:\windows\system32
	set arch=x64
if %PROCESSOR_ARCHITECTURE% == x86 (
	set arch=x86
  )
copy 7z%arch%.dll %root%\7z.dll /y
echo done.
echo extracting files ...
%root%\7z%arch%.exe e -o%root% -aoa tool.7z %arch%\*
::%root%\7z%arch%.exe x tool.gz -o%root%\ -y
::%root%\7z%arch%.exe x tool -o%root%\ -y
::move /y %root%\%arch%\*.* %root%\
::重命名
::Setlocal Enabledelayedexpansion
::set "str=%arch%"
::for /f "delims=" %%i in ('dir /b %root% *.*') do (
::set "var=%%i" & ren "%%i" "!var:%str%=!"
::)
Setlocal Disabledelayedexpansion

echo done.
echo starting services.....
sc create xFsRedirApp binpath= "%root%\xFsRedir.exe -server" displayname= "Fanxiushu File System Redirect Directory" start= auto
for %%i in (name installiso smb smbpath smbuser smbpass setupiso httptimeout command serverip checkwim silent p2p formatmbr formatgpt index) do (
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
echo index=%index%
echo smb=%smb%

:判断formatmbr值
if defined formatmbr (
    aria2c http://%serverip%/app/winsetup/format.bat.mbr -d X:\ >nul
	if exist X:\format.bat del /q X:\format.bat
	ren X:\format.bat.mbr format.bat
	call X:\format.bat
) else set formatmbr=
:判断formatgpt值
if defined formatgpt (
    aria2c http://%serverip%/app/winsetup/format.bat.gpt -d X:\ >nul
	if exist X:\format.bat del /q X:\format.bat
	ren X:\format.bat.gpt format.bat
	call X:\format.bat
) else set formatgpt=

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

:判断slient值
if defined slient (
    echo %slient%
) else set slient=1

:判断index值
if defined index (
    echo %index%
) else set index=


:生成cgi的配置文件
:buildcgi
(
echo [operation]
echo action=restore
echo silent=%silent%
echo [source]
echo %checkwim%^|%index%
echo [destination]
echo DriveLetter = system
echo [miscellaneous]
echo format = 1
echo fixboot=auto
echo shutdown=2
)>"%temp%\system.ini"


:判断smb值
if defined smb (
    goto smb
) else set smb=

:判断p2p值
if defined p2p (
   goto startp2p
) else set p2p=



:httpiso
echo []>%root%\xFsRedir.ini

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
)>>%root%\xFsRedir.ini
goto startmount


:startmount
ping 127.0 -n 2 >nul
net start "Fanxiushu File System Redirect Directory"

set xml=
if exist autounattend.xml (
  set xml=/Unattend:%root%\autounattend.xml
  echo Add parameter %xml%
)



:setupwin
echo wait.................
ipconfig
echo installiso:%isopath%
echo httptimeout:%httptimeout%
echo formatmbr: %formatmbr%
echo formatgpt: %formatgpt%
echo silent:%silent%
ping 127.0 -n %httptimeout% >nul
if exist Q:\setup.exe %command% %xml%
if not exist Q:\setup.exe goto try

:try
net stop "Fanxiushu File System Redirect Directory"
net start "Fanxiushu File System Redirect Directory"
echo try again........
ipconfig
echo installiso:%isopath%
echo httptimeout:%httptimeout%
echo formatmbr: %formatmbr%
echo formatgpt: %formatgpt%
echo silent:%silent%
ping 127.0 -n %httptimeout% >nul
if exist Q:\setup.exe %command% %xml%
if not exist Q:\setup.exe %command% %xml%
exit
:::::::::::::::::::::::::::::以下是p2p

:startp2p
ipconfig
echo installiso:%isopath%
echo httptimeout:%httptimeout%
echo formatmbr: %formatmbr%
echo formatgpt: %formatgpt%
echo silent:%silent%
echo warning!! p2pmode!!
if exist X:\winp2p.exe del /q X:\winp2p.exe
aria2c http://%serverip%/app/winsetup/winp2p.7z -d %root% >nul
if exist winp2p.7z %root%\7z%arch%.exe x winp2p.7z -o%root%\ -y
::taskkill /f /im verysync%arch%.exe
if exist %root%\pecmd.exe %root%\pecmd.exe kill verysync%arch%.exe
if exist start "" /min %root%\verysync%arch%.exe -home %root%\windata -gui-address :8886 -no-browser

:startcheck
if not exist %checkwim% (
echo syncing 正在同步!!!
ping 127.0 -n 6 >nul
) else (
echo ok，restore 同步完成!! &&goto cgi
)
:end
goto startcheck
:cgi
ping 127.0 -n %httptimeout% >nul

start "" "%root%\cgi.exe" %temp%\system.ini
exit

::其它功能
::echo list volume|diskpart|findstr /i Document >~tmp
::for /f "tokens=2" %%a in (~tmp) do set part=%%a
::cmd /c "echo sele disk 0 & echo sele part %part% & echo set id=12" | diskpart
::del ~tmp
::echo 找到盘 %part%
:smb
echo net use smb....
set 
net use \\%serverip%\%smbpath% "%smbpass%" /user:%smbuser%
echo []>%root%\xFsRedir.ini

echo building config....
setlocal enabledelayedexpansion
(
echo [vdir0]
echo mondir=Q:\
echo svrip=%serverip%
echo svrport=0
echo authstring=%smbpass%
echo rootdir=\%smbpath%
echo threadcount=55
echo proto_type=3
echo user=%smbuser%
echo cache_dir=
echo querytimeout=60
echo transtimeout=60
echo isansiname=0
echo iscasename=0
echo pathinfo_cache_timeout=55
echo memdisk_size=256
echo disable=0
echo isreadonly=0
)>>%root%\xFsRedir.ini
ping 127.0 -n 2 >nul
net start "Fanxiushu File System Redirect Directory"
cgi
exit




