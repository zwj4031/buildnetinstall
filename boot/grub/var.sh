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
#strconv --utf8 --set=name "${name}";

if [ "$grub_platform" = "efi" ]; then
		 
	export bootmenu=efiboot.sh;
	efivar;
else 
	
	export bootmenu=legacyboot.sh;
fi;

if [ -z "$serverip" ]; 
then
    export serverip=${net_default_server}
	save_env -f ${prefix}/ms/null.cfg serverip 
else	
    save_env -f ${prefix}/ms/null.cfg serverip 
fi;

function checkfile {
if [ -z "$setupiso" ]; 
then
export bootmode="网络启动wim"
export netwim_file=$setupwim
else  
unset netwim_file
fi;

if [ -z "$setupwim" ]; 
then
export bootmode="网络启动iso"
export netiso_file=$setupiso
else
unset netiso_file
fi;
}



    set installiso=http://${serverip}${setupiso};
    save_env -f ${prefix}/ms/null.cfg installiso
	
function getefivar {
if getargs --value "netwim" netwim_file;
then
export bootmode="网络启wim";
else
unset netwim_file;
fi;


if getargs --value "netiso" netiso_file;
then
export bootmode="网启iso";
else
unset netiso_file;
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
}	

function efivar {
   	getargs --value "proxydhcp" proxydhcp;
	getargs --value "httptimeout" httptimeout;
	getargs --key "mem" run_mem;
	getargs --value "autounattend" autounattend_file;
	regexp --set=1:run_ext '^.*\.(.*$)' "${run_file}";
	regexp --set=1:setupwim_ext '^.*\.(.*$)' "${setupwim_file}";
	regexp --set=1:netwim_ext '^.*\.(.*$)' "${netwim_file}";
	regexp --set=1:netiso_ext '^.*\.(.*$)' "${netiso_file}";
	regexp --set=1:autounattend_ext '^.*\.(.*$)' "${autounattend_file}";
	echo "启动文件:${run_file}${iso_file}";
	echo "执行文件: ${command}"
	echo "wim文件: ${setupwim}${netwim_file}";
	echo "iso文件: ${setupiso}${netiso_file}";
	echo "启动服务器: ${serverip}"
	echo "mem: ${run_mem}"
	echo "应答文件: ${autounattend}"
	
	export net_default_server="${proxydhcp}";
if [ "${run_mem}" = "1" ];
then
	set run_mem="--mem";
else
	set run_mem="";
fi;
	echo "file: ${run_file}";
	echo "type: ${run_ext}";
}



