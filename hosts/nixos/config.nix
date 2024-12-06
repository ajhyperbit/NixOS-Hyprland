# Main default config
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
  imports = [
  ];

  # BOOT related stuff
  boot = {
    #kernelPackages = pkgs.linuxPackages_latest; # Kernel

    kernelParams = [
      "amd_iommu=on"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];

    kernelModules = ["vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio"];

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };
  };

  drivers.nvidia.enable = true;
  #vm.guest-services.enable = false;

  networking = {
    hostName = "${host}";
    interfaces.enp6s0.wakeOnLan.enable = true;
  };
  environment.systemPackages = with pkgs; [
    davinci-resolve-studio
  ];

  #ANCHOR - Services

  services = {
    #DDNS config
    ddclient = {
      enable = true;
      configFile = "/etc/ddclient/ddclient.conf";
    };
    
  sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true; 
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
