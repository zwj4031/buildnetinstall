
echo off
echo ..............开始..........................
:: 获取管理员权限运行批处理

cmd /k

::::::::::::开始脚本

set arch=x64
if %PROCESSOR_ARCHITECTURE% == x86 (
  set arch=x86
  )
echo extracting files ...

::%~dp0\7z%arch% x xfscient.7z -o%~dp0\ -y

echo ok..

::net stop "Fanxiushu File System Redirect Directory"
sc create xFsRedirApp binpath= "%~dp0\xFsRedir%arch%.exe -server" displayname= "Fanxiushu File System Redirect Directory" start= auto
::sc create xfs_redir binpath= "%~dp0\xfs_redir.sys" displayname= "xfs_redir" start= auto
echo []>%~dp0\xFsRedir.ini
cls
echo 正在生成配置....
setlocal enabledelayedexpansion
(
echo [vdisk0]
echo disable=0
echo drive_letter=Q
echo disk_size=64
echo disk_type=1
echo is_cdrom=1
echo is_read_only=1
echo image_url=http://192.168.11.242/7.iso
echo user=
echo pwd=
echo nfs_mountdir=
:::下面的是线程数
echo threadcount=55
echo transtimeout=60
)>>%~dp0\xFsRedir.ini

net start "Fanxiushu File System Redirect Directory"
%~dp0\XfsRedir%arch%.exe -server
%~dp0\XfsRedir%arch%.exe
pause