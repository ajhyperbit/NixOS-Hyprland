{ 
  disko.rootMountPoint = "/";
  disko.devices = {
    disk = {
      DATA = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST2000NE0025-2FL101_ZDS1968N";
        content = {
          type = "gpt";
          partitions = {
            DATA = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "@" = {};
                  "@/DATA" = {
                    mountpoint = "/run/media/ajhyperbit/DATA";
                    mountOptions = [
                      "users" # Allows any user to mount and unmount
                      "nofail" # Prevent system from failing if this drive doesn't mount
                      "exec" # Permit execution of binaries and other executable files
                      "auto" #Mount the filesystem automatically
                      "compress=zstd" #Enable default zstd compression
                      "uid=ajhyperbit"
                      "gid=100"
                    ];
                  };
                  "@/.snapshots" = {
                    mountpoint = "/run/media/ajhyperbit/DATA/.snapshots";
                    mountOptions = [
                      "users" # Allows any user to mount and unmount
                      "nofail" # Prevent system from failing if this drive doesn't mount
                      "exec" # Permit execution of binaries and other executable files
                      "auto" #Mount the filesystem automatically
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
