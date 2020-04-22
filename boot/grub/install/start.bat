@echo off
%cd%\wpeinit.exe
ren %cd%\wpeinit.exe wpeinit.exe.old
set arch=x64
if %PROCESSOR_ARCHITECTURE% == x86 (
  set arch=x86
  )
echo Operating System is %arch% bit
echo Installing ISO Driver
mount.exe -xi
for /f "tokens=1,2 delims==" %%a in ('find "installiso=" null.cfg') do set isopath=%%b
echo ISO Path: %isopath%

for %%I in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do if exist %%I:%isopath% set isodrive=%%I:
if "%isodrive%"=="" (
echo ERROR - COULD NOT FIND ISO!

goto :EOF
)
echo ISO Full Path: %isodrive%%isopath%

mount.exe -m:r %isodrive%%isopath%

MODE CON COLS=30 LINES=4
cls
echo DO NOT CLOSE THIS WINDOW
echo Please wait ...
ping -n 6 127.0.0.1 >nul
for %%i in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
if exist %%i:\sources\install.wim call :wim %%i 
if exist %%i:\sources\install.esd call :esd %%i
if exist %%i:\%arch%\sources\install.* %%i:\%arch%\setup.exe 
if exist %%i:\%arch%\ call :End 
)
:wim
X:\setup.exe /installfrom:"%1:\sources\install.wim" 
goto :End
:esd
X:\setup.exe /installfrom:"%1:\sources\install.esd" 
goto :End
:End
echo.
echo Press any key to exit...
pause >nul
exit
