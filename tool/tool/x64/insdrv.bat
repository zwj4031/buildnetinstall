del /s /q X:\windows\system32\start*.ini
rd /s /q %temp%\pe-driver\
::aria2c http://192.168.11.242/net.7z -d X:\windows\system32\
::::aria2c http://192.168.11.242/start.ini -d X:\windows\system32\
pecmdx64 TEXT Ӵ��������װϵͳ����ʷ����ΰ�����������������ڽ�ѹ����װ����...  L204 T207 R1000 B268 $30:Microsoft YaHei UI 
:::pecmdx64 WAIT 5000
X:\windows\system32\7zx64.exe x X:\windows\system32\net.7z -o%temp%\pe-driver\
dpinst.exe /s /Path %temp%\pe-driver\
#dpinst.exe /s /Path %temp%\pe-driver\

exit
