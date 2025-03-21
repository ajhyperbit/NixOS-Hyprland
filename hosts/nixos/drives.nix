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

  #fileSystems."/run/media/ajhyperbit/DATA" = {
  #  device = "/dev/disk/by-uuid/2e7ff43d-029f-40ab-85af-aa0543f08bf2";
  #  fsType = "btrfs";
  #  options = [
  #    # If you don't have this options attribute, it'll default to "defaults"
  #    # boot options for fstab. Search up fstab mount options you can use
  #    "users" # Allows any user to mount and unmount
  #    "nofail" # Prevent system from failing if this drive doesn't mount
  #    "exec" # Permit execution of binaries and other executable files
  #    "auto" #Mount the filesystem automatically
  #  ];
  #};

  #fileSystems."/run/media/ajhyperbit/Archive" = {
  #  device = "/dev/disk/by-uuid/4fd45309-e0dc-4124-8c19-36c011aad8eb";
  #  label = "Archive";
  #  fsType = "btrfs";
  #  options = [
  #    "users" # Allows any user to mount and unmount
  #    "nofail" # Prevent system from failing if this drive doesn't mount
  #    "exec" # Permit execution of binaries and other executable files
  #    "noauto" #Do not mount the filesystem automatically
  #  ];
  #};
}
