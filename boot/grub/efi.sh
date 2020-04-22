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

set bootmode="不支持";
if getargs --value "netwim" netwim_file;
then
export bootmode="网启wim";
else
unset netwim_file;
fi;

if getargs --value "netiso" netiso_file;
then
export bootmode="网启iso";
else
unset netiso_file;
fi;

if getargs --value "netwim" netwim_file;
then
export bootmode="网启wim";
else
unset netwim_file;
fi;

if getargs --value "file" run_file;
then
export bootmode="本地启动";
else
unset run_file;
fi;


if getargs --value "iso" iso_file;
then
export bootmode="本地启动";
else
unset iso_file;
fi;

if getargs --value "setupwim" setupwim_file;
then
export bootmode="网络安装微软原版";
else
unset setupwim_file;
fi;

if getargs --value "setupiso" setupiso_file;
then
export bootmode="网络安装微软原版";
else
unset setupiso_file;
fi;

if getargs --value "autounattend" autounattend_file;
then
export bootmode="网络安装微软原版-自动应答文件";
else
unset autounattend_file;
fi;

if getargs --value "command" command_file;
then
export command=$command_file;
else
unset command_file;
fi;


menuentry "1.立即启动[模式:${bootmode}][设备:${net_default_server}][超时:$httptimeout]" --class nt6 {
    configfile ${prefix}/efiboot.sh;
}

menuentry "2.安装其它系统包" --class nt6 {
   #background_image ${prefix}/themes/qq/qq.png; getkey; configfile ${prefix}/menu.sh;
  configfile $prefix/loadlist.sh;
}


menuentry "3.启动不了-定制-大发慈悲-欢迎联系作者--史上最伟大网管[选中查看]" --class cong {
   #background_image ${prefix}/themes/qq/qq.png; getkey; configfile ${prefix}/menu.sh;
load_qq; configfile $prefix/qrcode.sh;
}


menuentry "本地启动文件:${run_file} ${iso_file}" --class wim {
    configfile ${prefix}/efiboot.sh;
}


menuentry "wim文件:${setupwim} ${netwim_file}" --class wim {
    configfile ${prefix}/efiboot.sh;
}

menuentry "iso文件:${setupiso} ${netiso_file}" --class iso {
    configfile ${prefix}/efiboot.sh;
}

menuentry "自动应答文件:${autounattend}" --class cfg {
    configfile ${prefix}/efiboot.sh;
}

menuentry "执行程序:${command}" --class cfg {
    configfile ${prefix}/efiboot.sh;
}



