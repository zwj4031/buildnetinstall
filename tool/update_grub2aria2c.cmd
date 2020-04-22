@echo off
if exist grub2-latest.tar.gz del /q grub2-latest.tar.gz
if exist grub rd /s /q grub
bin\aria2c -c -s 1 -o grub2-latest.tar.gz --seed-time=240 --seed-ratio=1.0 https://github.com/a1ive/grub/releases/download/latest/grub2-latest.tar.gz

::bin\wget https://github.com/a1ive/grub/releases/download/latest/grub2-latest.tar.gz -O grub2-latest.tar.gz >nul

bin\7z.exe e -ogrub -aoa  grub2-latest.tar.gz

pause
del grub2-latest.tar.gz
pause