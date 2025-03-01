{
  disko.devices = {
    #disk = {
    #  root = {
    #
    #  };
    #};

    disk = {
      SATASSD = {
        type = "disk";
        device = "/dev/disk/by-uuid/c879995c-386a-42c2-bc3b-8d02a03c61de";
        content = {
          type = "gpt";
          partitions = {
            SATASSD = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/@SATASSD" = {
                    mountpoint = "/run/media/ajhyperbit/SATA_SSD";
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
