# Main default config

{ config, pkgs, host, username, options, lib, inputs, system, ...}: 

let
  host = "nixos";

  inherit (import ./variables.nix) keyboardLayout;
  python-packages = pkgs.python3.withPackages (
    ps:
      with ps; [
        requests
        pyquery # needed for hyprland-dots Weather script
        ]
  );
  
  in {
  imports = [
    ./hardware.nix
    ./users.nix
    #../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    #../../modules/nvidia-prime-drivers.nix
    #../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
  ];

  # BOOT related stuff
  boot = {
    #kernelPackages = pkgs.linuxPackages_latest; # Kernel

    kernelParams = [
    "amd_iommu=on"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

    initrd = { 
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  drivers.nvidia.enable = true;
  #vm.guest-services.enable = false;


  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7435c3ee-ec8c-4653-943d-f00a3f50e5a5";
    fsType = "ext4";
  };

  #fileSystems."/boot" = {
  #device = "/dev/disk/by-uuid/7435c3ee-ec8c-4653-943d-f00a3f50e5a5";
  #fsType = "ext4";
  #};

  #fileSystems."/home" = {
  #device = "/dev/disk/by-uuid/7435c3ee-ec8c-4653-943d-f00a3f50e5a5";
  #fsType = "ext4";
  #};

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

  fileSystems."/run/media/ajhyperbit/Transfer" = {
    device = "/dev/disk/by-uuid/F7F7-F2D7";
    fsType = "exfat";
    options = [
      # If you don't have this options attribute, it'll default to "defaults" 
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount
      "exec" # Permit execution of binaries and other executable files
      #TODO: add to links https://github.com/NixOS/nixpkgs/issues/55807 ?
      "uid=1000"
      "gid=100"
      "dmask=007"
      "fmask=117"
    ];
  };

  #fileSystems."/run/media/ajhyperbit/SATA SSD1" = {
  #  device = "/dev/disk/by-uuid/DA4416764416561B";
  #  #fsType = "ntfs";
  #  options = [
  #    # If you don't have this options attribute, it'll default to "defaults" 
  #    # boot options for fstab. Search up fstab mount options you can use
  #    "users" # Allows any user to mount and unmount
  #    "nofail" # Prevent system from failing if this drive doesn't mount
  #    "exec" # Permit execution of binaries and other executable files
  #    #"noauto" # Do not auto mount, require explict mounting
  #    #"uid=1000"
  #    #"gid=100"
  #    #"dmask=007"
  #    #"fmask=117"
  #  ];
  #};

  #fileSystems."/run/media/ajhyperbit/DATA" = {
  #  device = "/dev/disk/by-uuid/7C120D0C120CCCD8";
  #  #fsType = "ntfs";
  #  options = [
  #    # If you don't have this options attribute, it'll default to "defaults" 
  #    # boot options for fstab. Search up fstab mount options you can use
  #    "users" # Allows any user to mount and unmount
  #    "nofail" # Prevent system from failing if this drive doesn't mount
  #    "exec" # Permit execution of binaries and other executable files
  #    #"noauto" # Do not auto mount, require explict mounting
  #    #"uid=1000"
  #    #"gid=100"
  #    #"dmask=007"
  #    #"fmask=117"
  #  ];
  #};
  
  #fileSystems."/run/media/ajhyperbit/Archive" = {
  #  device = "/dev/disk/by-uuid/D6C68616C685F751";
  #  #fsType = "ntfs";
  #  options = [
  #    # If you don't have this options attribute, it'll default to "defaults" 
  #    # boot options for fstab. Search up fstab mount options you can use
  #    "users" # Allows any user to mount and unmount
  #    "nofail" # Prevent system from failing if this drive doesn't mount
  #    "exec" # Permit execution of binaries and other executable files
  #    #"noauto" # Do not auto mount, require explict mounting
  #    #"uid=1000"
  #    #"gid=100"
  #    #"dmask=007"
  #    #"fmask=117"
  #  ];
  #};

  #fileSystems."/run/media/ajhyperbit/Windows" = {
  #  device = "/dev/disk/by-uuid/80B872A7B8729AFC";
  #  #fsType = "ntfs";
  #  options = [
  #    # If you don't have this options attribute, it'll default to "defaults" 
  #    # boot options for fstab. Search up fstab mount options you can use
  #    "users" # Allows any user to mount and unmount
  #    "nofail" # Prevent system from failing if this drive doesn't mount
  #    "exec" # Permit execution of binaries and other executable files
  #    #"noauto" # Do not auto mount, require explict mounting
  #    #"uid=1000"
  #    #"gid=100"
  #    #"dmask=007"
  #    #"fmask=117"
  #  ];
  #};


  #console = {
  #  packages = [pkgs.terminus_font];
  #  font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
  #  useXkbConfig = true;
  #};

  networking.hostName = "${host}";

  #ANCHOR - Services

  services = {
    #DDNS config
    ddclient = {
      enable = true;
      configFile = "/etc/ddclient/ddclient.conf";
    };
  };

  environment = {
    #shellAliases = {
    #  google-chrome = "google-chrome-stable"
    #};
    variables = {
      #QT_STYLE_OVERRIDE = "breeze";
      #QT_QPA_PLATFORMTHEME= "qt5ct";
    };

    sessionVariables = {
    no_hardware_cursors = "true";
    #WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    #KDE_FULL_SESSION = "true";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    #QT_QPA_PLATFORM = "wayland;xcb";
    #QT_QPA_PLATFORMTHEME= "qt5ct";
    #GDK_BACKEND = "wayland,x11,*";
    #NVD_BACKEND = "direct";
  };
  };

  #XDG Portals
  xdg = {
    #autostart.enable = true;
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [ 
        #xdg-desktop-portal
        #xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
        #xdg-desktop-portal-hyprland
      ];
      xdgOpenUsePortal = true;
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];

    config = {
    #  common = {
    #    default = [
    #      "kde"
    #      ];
    #  };
      #"org.freedesktop.impl.portal.FileChooser"= [
      #  "kde"
      #    ];
    };
    };
  };

  # Microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}