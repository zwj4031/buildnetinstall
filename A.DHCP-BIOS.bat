echo off
echo ..............开始..........................

taskkill /f /im pxesrv.exe
if not exist %~dp0boot mkdir %~dp0boot
for /f %%i in ('dir /b %~dp0*.iso') do set setupiso=/%%i
if not exist %~dp0\boot\boot.wim %~dp0\bin\7z.exe e -oboot -aoa  %1 sources/boot.wim


:: 获取管理员权限运行批处理
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs" 1>nul 2>nul
exit /b
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" ) 1>nul 2>nul

(
echo #!ipxe
echo set setupwim^= /boot/boot.wim
echo set setupiso^= %setupiso%
echo set httptimeout^= 6
echo set autounattend^=
echo isset ${proxydhcp/dhcp-server} ^&^& chain http://^${proxydhcp/dhcp-server}/netinstall.${platform} proxydhcp=^${proxydhcp/dhcp-server} setupwim=${setupwim=} setupiso=${setupiso=} httptimeout=${httptimeout=} autounattend=${autounattend=} ^|^|
echo chain http://^${next-server}/netinstall.${platform} proxydhcp=^${next-server} setupwim=${setupwim=} setupiso=${setupiso=} httptimeout=${httptimeout=} autounattend=${autounattend=} 
) >%~dp0\netinstall.ipxe
(
echo [0]
echo name=微软原版安装
echo icon=iso
echo setupwim=/boot/boot.wim
echo setupiso=%setupiso%
echo command=Q:\\setup.exe
echo httptimeout=6
echo formatmbr=
echo formatgpt=
echo p2p=
echo command=
echo autounattend=
echo serverip=
)>%~dp0\app\winsetup\netinstall.ini

(
echo [dhcp]
echo start=1
echo proxydhcp=1
echo httpd=1
echo bind=1
echo poolsize=998
echo root=%~dp0
echo filename=ipxe-undionly.bios
echo altfilename=netinstall.ipxe
)>%~dp0\config.INI
start ""  %~dp0\pxesrv.exe
exit
