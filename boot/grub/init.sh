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

#set pager=0;
#set debug=off;

#set pager=0;
#set debug=off;
#UEFI LoadOptions
set pager=0;
cat --set=modlist ${prefix}/insmod.lst;
for module in ${modlist};
do
    insmod ${module};
done;
export proxydhcp = "0";	




export enable_progress_indicator=0;
set pager=0;
set debug=off;
set color_normal=white/black;
set color_highlight=black/white;
export grub_prompt="C:\>";
export grub_frame_speed=110


function load_gfx {
  loadfont ${prefix}/fonts/unicode.xz;
  loadfont ${prefix}/fonts/dosvga.pf2;
  export grub_disable_esc="1";
  export gfxmode=1024x768;
  export gfxpayload=keep;
  terminal_output gfxterm;
  #export theme=${prefix}/themes/boot/splash7.txt;
  export theme=${prefix}/themes/boot/splash10.txt;
   #export theme=${prefix}/themes/av/av.txt;
set timeout=10;
}

function load_qq {
  loadfont ${prefix}/fonts/unicode.xz;
  loadfont ${prefix}/fonts/dosvga.pf2;
  export grub_disable_esc="1";
  export gfxmode=auto;
  export gfxpayload=keep;
  terminal_output gfxterm;
  #export theme=${prefix}/themes/boot/splash7.txt;
  export theme=${prefix}/themes/qq/qq.txt;
   #export theme=${prefix}/themes/av/av.txt;
set timeout=50;
}

function print_help {
  echo "  _____               _      ______  __  __ ";
  echo " / ____|             | |    |  ____||  \/  |";
  echo "| |  __  _ __  _   _ | |__  | |__   | \  / |";
  echo "| | |_ || '__|| | | || '_ \ |  __|  | |\/| |";
  echo "| |__| || |   | |_| || |_) || |     | |  | |";
  echo " \_____||_|    \__,_||_.__/ |_|     |_|  |_|";
  echo "┌──────────────────────────────────────────┐";
  echo "│       Copyright © 2016-2020 a1ive        │";
  echo "└──────────────────────────────────────────┘";
  echo "Usage:";
  echo "  chainloader /run.efi [OPTIONS] file=FILE | disk=(hdx,y) | dir=PATH";
  echo "      file=FILE    -- Boot file (EFI/IMG/ISO/VHD/WIM).";
  echo "      disk=(hdx,y) -- Boot disk (hdx,y)";
  echo "      dir=PATH     -- List files in directory";
  echo "    options:";
  echo "      efiguard     -- Load EfiGuardDxe to disable PatchGuard and DSE.";
  echo "      slic[=FILE]  -- Load SLIC table.";
  echo "      msdm[=FILE]  -- Load MSDM table.";
  echo "      text         -- Disable GFX menu.";
  echo "";
  echo "GrubFM Usage:";
  echo "  grubfm [PATH]    -- List files in directory";
  echo "  grubfm_open FILE -- Boot file."
  echo "";
  echo "Press any key to enter command line ...";
  getkey;
  commandline;
}

function try_disk {
  if [ -d "${run_disk}/Windows" -o -d "${run_disk}/windows" -o -d "${run_disk}/WINDOWS" ];
  then
    ntboot --gui --win \
           --efi=${prefix}/ms/bootmgfw.efi \
           "${run_disk}";
  elif [ -f "${run_disk}/EFI/BOOT/BOOTX64.EFI" ];
  then
    chainloader -b "${run_disk}/EFI/BOOT/BOOTX64.EFI";
  elif [ -f "${run_disk}/EFI/Microsoft/Boot/bootmgfw.efi" ];
  then
    chainloader -b "${run_disk}/EFI/Microsoft/Boot/bootmgfw.efi";
  fi;
}

function loadoptions {
if getargs --key "efiguard" run_efiguard;
then
  efiload ${prefix}/drivers/EfiGuardDxe.efi;
fi;

if getargs --value "slic" run_slic;
then
  acpi --slic "${run_slic}";
elif getargs --key "slic" run_slic;
then
  acpi --slic ${prefix}/slic/slic.bin;
fi;

if getargs --value "msdm" run_msdm;
then
  acpi --msdm "${run_msdm}";
elif getargs --key "msdm" run_msdm;
then
  acpi --msdm ${prefix}/slic/msdm.bin;
fi;

if getargs --value "file" run_file;
then
  grubfm_open "${run_file}";
fi;

if getargs --value "disk" run_disk;
then
  try_disk;
fi;

if getargs --key "text" run_text;
then
  terminal_output console;
else
  load_gfx;
fi;

if getargs --key "help" run_help;
then
  print_help;
fi;

#if getargs --value "dir" run_dir;
#then
#  grubfm "${run_dir}";
#else
#  grubfm;
#fi;
}
	 
function biosmenu {
menuentry "net install windows" {
    export timeout=20
set func=default; lua $prefix/getini.lua; configfile $prefix/legacybios.sh;
}
}
function efimenu {
menuentry "net install windows" {
set func=default; lua $prefix/getini.lua; configfile $prefix/efi.sh;
}
}


     if [ "$grub_platform" = "efi" ]; then
getargs --value "proxydhcp" proxydhcp;
export net_default_server="${proxydhcp}"; 	
loadoptions; 
efimenu;
else 
load_gfx;
biosmenu;
     fi;

