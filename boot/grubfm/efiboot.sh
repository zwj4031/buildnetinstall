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
source $prefix/var.sh; 
set enable_progress_indicator=1;

loopback -m wimboot ${prefix}/ms/wimboot.gz;

if regexp '^[eE][fF][iI]$' "${run_ext}";
then
  chainloader -b "${run_file}";
elif regexp '^[iI][mM][aAgG]$' "${run_ext}";
then
  map ${run_mem} "${run_file}";
elif regexp '^[iI][sS][oO]$' "${run_ext}";
then
  map ${run_mem} "${run_file}";
elif regexp '^[vV][hH][dD]$' "${run_ext}";
then
  ntboot --gui \
         --efi=(wimboot)/bootmgfw.efi \
         --sdi=(wimboot)/boot.sdi \
         "${run_file}";
elif regexp '^[vV][hH][dD][xX]$' "${run_ext}";
then
  ntboot --gui \
         --efi=(wimboot)/bootmgfw.efi \
         --sdi=(wimboot)/boot.sdi \
         "${run_file}";
elif regexp '^[wW][iI][mM]$' "${run_ext}";
then
  wimboot --gui \
          @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
          @:bcd:(wimboot)/bcd \
          @:boot.sdi:(wimboot)/boot.sdi \
		  @:boot.wim:"${run_file}";		  
###############添加自煮研发的

		  
elif regexp '^[iI][sS][Oo]$' "${netiso_ext}";
then
  echo "enable_progress_indicator=1; loading (http)${netiso_file} ......";
  map --mem "(http)${netiso_file}";

elif regexp '^[wW][iI][mM]$' "${setupwim_ext}";
then
  wimboot --gui \
          @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
          @:bcd:(wimboot)/bcd \
          @:boot.sdi:(wimboot)/boot.sdi \
		  @:winpeshl.ini:${prefix}/ms/winpeshl.ini \
		  @:startup.bat:${prefix}/ms/startup.bat \
		  @:null.cfg:${prefix}/ms/null.cfg \
		  @:7zx64.exe:${prefix}/ms/7zx64.exe \
		  @:7zx64.dll:${prefix}/ms/7zx64.dll \
		  @:7zx86.exe:${prefix}/ms/7zx86.exe \
		  @:7zx86.dll:${prefix}/ms/7zx86.dll \
		  @:tool.7z:${prefix}/ms/tool.7z \
		  @:boot.wim:"(http)/${setupwim}";
		  
elif regexp '^[xX][mM][lL]$' "${autounattend_ext}";
then
  save_env -f ${prefix}/ms/null.cfg installiso
  save_env -f ${prefix}/ms/null.cfg httptimeout
  save_env -f ${prefix}/ms/null.cfg command
  wimboot --gui \
          @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
          @:bcd:(wimboot)/bcd \
          @:boot.sdi:(wimboot)/boot.sdi \
		  @:winpeshl.ini:${prefix}/ms/winpeshl.ini \
		  @:startup.bat:${prefix}/ms/startup.bat \
		  @:null.cfg:${prefix}/ms/null.cfg \
		  @:7zx64.exe:${prefix}/ms/7zx64.exe \
		  @:7zx64.dll:${prefix}/ms/7zx64.dll \
		  @:7zx86.exe:${prefix}/ms/7zx86.exe \
		  @:7zx86.dll:${prefix}/ms/7zx86.dll \
		  @:autounattend.xml:(http)/${autounattend_file} \
		  @:tool.7z:${prefix}/ms/tool.7z \
		  @:boot.wim:"(http)/${setupwim}";
		  
elif regexp '^[wW][iI][mM]$' "${netwim_ext}";
then

  wimboot --gui \
          @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
          @:bcd:(wimboot)/bcd \
          @:boot.sdi:(wimboot)/boot.sdi \
		  @:boot.wim:"(http)/${netwim_file}";

 
elif regexp '^[wW][iI][mM]$' "${netwim_ext}";
then

  wimboot --gui \
          @:bootmgfw.efi:(wimboot)/bootmgfw.efi \
          @:bcd:(wimboot)/bcd \
          @:boot.sdi:(wimboot)/boot.sdi \
		  @:boot.wim:"(http)/${netwim_file}";
		  
else

		  

 #############完成研发 
          echo "错误: 不支持的文件类型!";
  exit;
fi;



