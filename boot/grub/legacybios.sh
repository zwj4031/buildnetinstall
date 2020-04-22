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

if setupiso != ""
then
export bootmode="网络安装微软原版";
else
set bootmode="不支持";
fi;

menuentry "1.立即启动[模式:${bootmode}][设备:${net_default_server}][超时:$httptimeout]" --class nt6 {
    configfile ${prefix}/legacyboot.sh;
}

menuentry "2.安装其它系统包" --class nt6 {
   #background_image ${prefix}/themes/qq/qq.png; getkey; configfile ${prefix}/menu.sh;
  configfile $prefix/loadlist.sh;
}

menuentry "3.启动不了-定制-大发慈悲-欢迎联系作者--史上最伟大网管[选中查看]" --class cong {
   #background_image ${prefix}/themes/qq/qq.png; getkey; configfile ${prefix}/menu.sh;
load_qq; configfile $prefix/qrcode.sh;
}


menuentry "本地启动文件:${run_file} " --class wim {
    configfile ${prefix}/legacyboot.sh;
}


menuentry "wim文件:${setupwim_file} ${setupwim}" --class wim {
    configfile ${prefix}/legacyboot.sh;
}

menuentry "iso文件:${setupiso_file} ${setupiso}" --class iso {
    configfile ${prefix}/legacyboot.sh;
}

menuentry "自动应答文件:${autounattend}" --class cfg {
    configfile ${prefix}/legacyboot.sh;
}

