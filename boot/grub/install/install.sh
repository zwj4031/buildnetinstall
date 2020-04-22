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

function installwin {
  regexp --set=1:installiso '(/.*)$' "${2}";
  tr --set=installiso "/" "\\";
  loopback -m envblk ${prefix}/install/null.cpio
  save_env -s -f (envblk)/null.cfg installiso;
  cat (envblk)/null.cfg;
  wimboot @:bootmgfw.efi:${prefix}/ms/bootmgfw.efi \
          @:bcd:${prefix}/ms/bcd \
          @:boot.sdi:${prefix}/ms/boot.sdi \
          @:null.cfg:(envblk)/null.cfg \
          @:mount.exe:${prefix}/install/mount.exe \
          @:start.bat:${prefix}/install/start.bat \
          @:winpeshl.ini:${prefix}/install/winpeshl.ini \
          @:boot.wim:"${1}";
}

loopback -d loop;
loopback loop "${run_file}";
set win_prefix=(loop)/sources/install;
set w64_prefix=(loop)/x64/sources/install;
if [ -f ${win_prefix}.wim -o -f ${win_prefix}.esd -o -f ${win_prefix}.swm ];
then
  installwin "(loop)/sources/boot.wim" "${run_file}";
elif [ -f ${w64_prefix}.wim -o -f ${w64_prefix}.esd -o -f ${w64_prefix}.swm ];
then
  installwin "(loop)/x64/sources/boot.wim" "${run_file}";
fi;
