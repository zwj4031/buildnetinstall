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
unset grub_frame_speed;
export theme=${prefix}/themes/slack/theme.txt;
source $prefix/var.sh;


if [ "$grub_platform" = "efi" ];
then
set defaultmode=efiboot;
set platform=UEFI;
getefivar;
   
elif [ "$grub_platform" = "pc" ];
then
set defaultmode=legacyboot;
set platform=传统BIOS;
fi;


if [ -z "$setupwim" -a -z "$setupiso" ]; 
then
export bootmode="不支持";
fi;

if [ -n "$setupwim" -a -n "$setupiso" ]; 
then
export bootmode="网络安装微软原版";
fi;


if [ -z "$setupiso" ]; 
then
export bootmode="网络启动wim";
export netwim_file=$setupwim;
set defaultmode="wimboot";
else  
unset netwim_file;
fi;

if [ -z "$setupwim" ]; 
then
export bootmode="网络启动iso";
export netiso_file=$setupiso;
set defaultmode="mapiso";
else
unset netiso_file;
fi;




menuentry "1.立即启动--模式:[${platform}][${bootmode}][超时:$httptimeout]" --class nt6 {
   set func=$defaultmode; j=0; lua $prefix/open.lua;
}

menuentry "2.更多系统--自定义[/app/winsetup/netinstall.ini]" --class nt6 {
   #background_image ${prefix}/themes/qq/qq.png; getkey; configfile ${prefix}/menu.sh;
  configfile $prefix/loadlist.sh;
}

menuentry "3.捐助作者--bug反馈[选中查看]" --class cong {
   #background_image ${prefix}/themes/qq/qq.png; getkey; configfile ${prefix}/menu.sh;
load_qq; configfile $prefix/qrcode.sh;
}
menuentry "4.当前设备--${net_default_server}[选中切换]" --class wim {
echo 请输入IP或域名:; read net_default_server; export net_default_server; configfile $prefix/main.sh;
}

menuentry "5.WIM文件:${setupwim_file} ${setupwim}" --class wim {
 load_qq; configfile $prefix/qrcode.sh;
}

menuentry "6.ISO文件:${setupiso_file} ${setupiso} 应答文件:${autounattend}" --class iso {
 load_qq; configfile $prefix/qrcode.sh;
}

menuentry "p2p:${p2p} smb:${smb} 静默:${silent} 系统:${checkwim} 分卷:${index} 分区mbr:${formatmbr} gpt:${formatbpt} [刷新]" --class cfg {
  configfile $prefix/init.sh
}


