{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  self,
  home,
  stateVersion-host-iso,
  ...
}: {
  imports = [
    ./users.nix
    ../../modules/local-hardware-clock.nix
  ];

  boot = {
    kernelParams = [
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
      "nowatchdog"
      #"modprobe.blacklist=sp5100_tco" #watchdog for AMD
      #"modprobe.blacklist=iTCO_wdt" #watchdog for Intel
      "nohibernate"
    ];
    tmp.cleanOnBoot = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };

    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    plymouth.enable = false;
  };

  drivers.intel.enable = true;

  local.hardware-clock.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    google-chrome
    firefox
    gparted
    gitFull
    vscode-fhs
    btop
  ];

  # Set your time zone.
  time.timeZone = "America/Chicago";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    desktopManager.plasma6.enable = true;
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
    };

    displayManager = {
      sddm = {
        enable = true;
      };
    };
  };

  #ANCHOR Programs

  programs = {
    firefox.enable = true;
    git.enable = true;

    zsh = {
      enable = true;
      enableBashCompletion = true;
    };

    thunar.enable = true;
    thunar.plugins = with pkgs; [
      xfce.exo
      xfce.mousepad
      xfce.thunar-archive-plugin
      xfce.thunar-volman
      xfce.thunar-media-tags-plugin
      xfce.tumbler
      ffmpegthumbnailer
      webp-pixbuf-loader
      poppler
      libgsf
      totem
      gnome-epub-thumbnailer
      mcomix
      f3d
    ];

    #KDE window borders fix
    dconf.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    #TODO: (Research) Something coding related (VS code talks about it)
    direnv.enable = true;

    nix-ld = {
      enable = true;
    };
  };

  fonts = {
    #Fonts support
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
    };
  };

  qt = {
    enable = true;
    style = "breeze";
    platformTheme = "kde";
  };

  security = {
    rtkit.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  documentation.nixos.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = stateVersion-host-iso; # Did you read the comment?
}
