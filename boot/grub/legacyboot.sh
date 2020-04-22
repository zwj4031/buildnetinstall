# Grub2-FileManager
# Copyright (C) 2016,2017,2018,2019,2020  A1ive.
#
# Grub2-FileManager is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Grub2-FileManager is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Grub2-FileManager.  If not, see <http://www.gnu.org/licenses/>.
#UEFI LoadOptions
##################################################################################

##网络安装加入开始	
#source $prefix/var.sh;
##############添加自煮研发的
source $prefix/var.sh;
 

loopback -m wimboot ${prefix}/ms/wimboot.gz;
 set lang=en_US;
terminal_output console;
set enable_progress_indicator=1;
linux16 (wimboot)/wimboot;
 if [ -z "$autounattend" ]; 
 then
 initrd16 newc:winpeshl.ini:${prefix}/ms/winpeshl.ini \
	  newc:startup.bat:${prefix}/ms/startup.bat \
	  newc:null.cfg:${prefix}/ms/null.cfg \
	  newc:7zx64.exe:${prefix}/ms/7zx64.exe \
	  newc:7zx64.dll:${prefix}/ms/7zx64.dll \
	  newc:7zx86.exe:${prefix}/ms/7zx86.exe \
	  newc:7zx86.dll:${prefix}/ms/7zx86.dll \
	  newc:tool.7z:${prefix}/ms/tool.7z \
      newc:bootmgr:(wimboot)/bootmgr \
      newc:bootmgr.exe:(wimboot)/bootmgr.exe \
	  newc:BCD:(wimboot)/bcd \
	  newc:boot.sdi:(wimboot)/boot.sdi \
	  newc:boot.wim:(http)/${setupwim};
else
 initrd16 newc:winpeshl.ini:${prefix}/ms/winpeshl.ini \
	  newc:startup.bat:${prefix}/ms/startup.bat \
	  newc:null.cfg:${prefix}/ms/null.cfg \
	  newc:7zx64.exe:${prefix}/ms/7zx64.exe \
	  newc:7zx64.dll:${prefix}/ms/7zx64.dll \
	  newc:7zx86.exe:${prefix}/ms/7zx86.exe \
	  newc:7zx86.dll:${prefix}/ms/7zx86.dll \
	  newc:tool.7z:${prefix}/ms/tool.7z \
	  newc:autounattend.xml:(http)/$autounattend \
      newc:bootmgr:(wimboot)/bootmgr \
      newc:bootmgr.exe:(wimboot)/bootmgr.exe \
	  newc:BCD:(wimboot)/bcd \
	  newc:boot.sdi:(wimboot)/boot.sdi \
	  newc:boot.wim:(http)/${setupwim};
   
 fi;
 

   
 