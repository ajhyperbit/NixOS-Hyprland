{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        #device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S58SNM0RC03948A";
        content = {
          type = "gpt";
          partitions = {
            EFI = {
              start = "2MiB";
              end = "1G";
              type = "EF00";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  "@" = {};
                  "@/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd" #Enable default zstd compression
                      "noatime"
                    ];
                  };
                  "@/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd" #Enable default zstd compression
                      "noatime"
                    ];
                  };
                  "@/.snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [
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
    {
    type = "disk";
      device = "";
      content = {
        type = "gpt";
        partitions = {
              
      };
    };

    };
  }
}
