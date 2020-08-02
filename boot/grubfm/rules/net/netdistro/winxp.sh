source ${prefix}/func.sh;

menuentry $"Install Windows XP - STEP 1" --class nt5 {
  set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/INSTALLXP cd ${grubfm_path};";
  linux ${prefix}/grub.exe --config-file=${g4d_cmd};
  initrd ${prefix}/winvblk.gz;
}

menuentry $"Install Windows XP - STEP 2" --class nt5 {
  set g4d_cmd="find --set-root --ignore-floppies /fm.loop;/INSTALLXP hd ${grubfm_path};";
  linux ${prefix}/grub.exe --config-file=${g4d_cmd};
  initrd ${prefix}/winvblk.gz;
}
