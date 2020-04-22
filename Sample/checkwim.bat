@echo off
if exist X:\winp2p.exe del /q X:\winp2p.exe
aria2c http://192.168.11.242/app/winsetup/winp2p.exe -d X:\ >nul
start "" /min cmd /c X:\winp2p.exe
:startcheck
if not exist I:\system.wim echo 正在同步…… &&timeout 10 >nul
if exist I:\system.wim echo 同步完成，准备还原…… &&timeout 55&&exit
:end
goto startcheck
