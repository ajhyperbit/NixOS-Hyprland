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

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    google-chrome
    gparted
    gitFull
    vscode-fhs
    btop
  ];

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    firewall.allowedTCPPorts = [5900 24800];
    #firewall.allowedUDPPorts = [ ... ];
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      # required to connect to Tailscale exit nodes
      checkReversePath = "loose";
    };
  };

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
      #Allow X11vnc through SSH. (probably unneccesary with tailscale)
      settings.X11Forwarding = true;
    };

    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
    };

    flatpak.enable = true;

    dbus.enable = true;

    #Different Compositor that might be conflicting
    #picom.enable = true;

    #gnome.gnome-keyring.enable = true;

    tailscale = {
      enable = true;
      openFirewall = true;
      extraSetFlags = [
        "--advertise-exit-node"
      ];
      useRoutingFeatures = "both";
    };

    envfs.enable = true;

    #clamav = {
    #  scanner.enable = true;
    #  updater.enable = true;
    #};

    fstrim = {
      enable = true;
      interval = "weekly";
    };

    displayManager = {
      sddm = {
        enable = true;
        #wayland.enable = true;
        #theme = "catppuccin-mocha";
      };
      autoLogin = {
        enable = false;
        user = "ajhyperbit";
      };
    };

    xserver = {
      enable = false;
      #Keyboard
      #xkb = {
      #  layout = "us";
      #  variant = "";
      #};

      #desktopManager.plasma5.enable = true;

      #displayManager = {
      #  #x11VNC / VNC
      #  sessionCommands = ''
      #    ${pkgs.x11vnc}/bin/x11vnc -bg -reopen -forever -rfbauth $HOME/.vnc/passwd -display :0 &
      #  '';
      #};
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber = {
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
            wireplumber.settings = {
              bluetooth.autoswitch-to-headset-profile = false
            }'')
        ];
        extraConfig = {
          "log-level-debug" = {
            "context.properties" = {
              # Output Debug log messages as opposed to only the default level (Notice)
              "log.level" = "D";
            };
          };
          "wh-1000xm3-ldac-hq" = {
            "monitor.bluez.rules" = [
              {
                matches = [
                  {
                    # Match any bluetooth device with ids equal to that of a WH-1000XM3
                    "device.name" = "~bluez_card.*";
                    "device.product.id" = "0x0cd3";
                    "device.vendor.id" = "usb:054c";
                  }
                ];
                actions = {
                  update-props = {
                    # Set quality to high quality instead of the default of auto
                    "bluez5.a2dp.ldac.quality" = "hq";
                  };
                };
              }
            ];
          };
        };
      };
    };

    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
        };
      };
    };

    smartd = {
      enable = false;
      autodetect = true;
    };

    gvfs.enable = true;
    tumbler.enable = true;

    udev.enable = true;

    libinput.enable = true;

    rpcbind.enable = false;
    nfs.server.enable = false;

    upower.enable = true;

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    onedrive.enable = true;
  };

  users.users.ajhyperbit = {
    isNormalUser = true;
    description = "AJHyperBit";
    extraGroups = [
      "flatpak"
      "disk"
      "qemu"
      "kvm"
      "libvirtd"
      "sshd"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "libvirtd"
      "root"
      "greeter"
      "gamemode"
      "seat" #do I need this?
    ];

    password = "";
  };

  users.users.root = {
    password = "";
  };

  #ANCHOR Programs

  programs = {
    hyprlock.enable = true;
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

    nh = {
      enable = true;
    };

    #KDE window borders fix
    dconf.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    #Virtualization (Windows VM) #TODO: move to it's own module (unsure if laptop will ever do some kind of Windows VM stuff, might just RDP/Parsec/VNC into it.)
    virt-manager.enable = true;

    ssh = {
      #KDE
      #askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
      #Gnome / Seahorse
      #askPassword = lib.mkForce "${pkgs.gnome.seahorse}/libexec/seahorse/ssh-askpass";
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

  systemd = {
    services.flatpak-repo = {
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

    #Sleep settings
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
  };

  # zram
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = stateVersion-host-iso; # Did you read the comment?
}
