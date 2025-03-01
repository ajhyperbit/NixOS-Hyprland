{
  disko.devices = {
    disk = {
      Archive = {
        type = "disk";
        device = "/dev/disk/by-uuid/4fd45309-e0dc-4124-8c19-36c011aad8eb";
        content = {
          type = "gpt";
          partitions = {
            Archive = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/@Archive" = {
                    mountpoint = "/run/media/ajhyperbit/Archive";
                    mountOptions = [
                      "users" # Allows any user to mount and unmount
                      "nofail" # Prevent system from failing if this drive doesn't mount
                      "exec" # Permit execution of binaries and other executable files
                      "noauto" #Do not mount the filesystem automatically
                      "compress=zstd" #Enable default zstd compression
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
