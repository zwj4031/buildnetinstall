@echo off
if exist X:\winp2p.exe del /q X:\winp2p.exe
aria2c http://192.168.11.242/app/winsetup/winp2p.exe -d X:\ >nul
start "" /min cmd /c X:\winp2p.exe
:startcheck
if not exist I:\system.wim echo ����ͬ������ &&timeout 10 >nul
if exist I:\system.wim echo ͬ����ɣ�׼����ԭ���� &&timeout 55&&exit
:end
goto startcheck
