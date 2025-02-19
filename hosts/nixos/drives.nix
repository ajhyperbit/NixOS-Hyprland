{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  ...
}: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7435c3ee-ec8c-4653-943d-f00a3f50e5a5";
    fsType = "ext4";
  };

  fileSystems."/run/media/ajhyperbit/SATA SSD" = {
    device = "/dev/disk/by-uuid/c879995c-386a-42c2-bc3b-8d02a03c61de";
    fsType = "ext4";
    options = [
      # If you don't have this options attribute, it'll default to "defaults"
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount
      "exec" # Permit execution of binaries and other executable files
    ];
  };

  #fileSystems."/run/media/ajhyperbit/Archive" = {
  #  device = "/dev/disk/by-uuid/9074e293-b54e-4139-b991-7a8064533f66";
  #  fsType = "btrfs";
  #  options = [
  #    # If you don't have this options attribute, it'll default to "defaults"
  #    # boot options for fstab. Search up fstab mount options you can use
  #    "users" # Allows any user to mount and unmount
  #    "nofail" # Prevent system from failing if this drive doesn't mount
  #    "exec" # Permit execution of binaries and other executable files
  #    "noauto" #Do not mount the filesystem automatically
  #  ];
  #};
}
