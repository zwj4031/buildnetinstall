taskkill /f /im hfs.exe
start "" /min %~dp0\bin\hfs.exe -c active=yes -a myhfs.ini
for /f %%a in ('dir /b/a-d  %~dp0\*.*') do start "" /min %~dp0\bin\hfs.exe %%a
start "" /min %~dp0\bin\hfs.exe  %~dp0\app
exit
