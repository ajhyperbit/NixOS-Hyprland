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
  self,
  home,
  ...
}: let
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
    ./users.nix
    ../../modules/local-hardware-clock.nix
  ];

  # BOOT related stuff
  boot = {
    #LINK - list of nix aliases https://github.com/NixOS/nixpkgs/blob/108230cebc6c328aa44f834d0aad647e26fcddc5/pkgs/top-level/aliases.nix
    #LINK - https://github.com/NixOS/nixpkgs/blob/108230cebc6c328aa44f834d0aad647e26fcddc5/pkgs/top-level/linux-kernels.nix
    #LINK - https://en.wikipedia.org/wiki/Linux_kernel_version_history
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; #Generic latest kernel

    #Zen Kernel
    #LINK - https://wiki.archlinux.org/index.php?title=Kernels&oldid=407966#Official_packages
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen; # Zen Kernel EOL: ???

    #kernelPackages = lib.mkDefault pkgs.linuxPackages_6_12; # LTS Kernel 6.12 EOL: ???
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_6_6; # LTS Kernel 6.6 EOL: 12/2026
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_6_1; # SLTS Kernel 6.1 EOL: 8/2033

    #LINK - https://github.com/NixOS/nixpkgs/blob/108230cebc6c328aa44f834d0aad647e26fcddc5/pkgs/os-specific/linux/kernel/xanmod-kernels.nix
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod; # Main xanmod Kernel EOL: ???
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_stable; # Stable 6.6 xanmod Kernel EOL: ???
    #kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest; # Latest xanmod Kernel EOL: ???

    kernelParams = [
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
      "nowatchdog"
      #"modprobe.blacklist=sp5100_tco" #watchdog for AMD
      #"modprobe.blacklist=iTCO_wdt" #watchdog for Intel
      "nohibernate"
    ];
    tmp.cleanOnBoot = true;
    #supportedFilesystems = ["ntfs"];
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

  local.hardware-clock.enable = true;

  nix = {
    settings = {
      #warn-dirty = false;
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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

      overlays = [
      ];

      packageOverrides = pkgs: {
        steam = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              libkrb5
              keyutils
              gamescope
              mangohud
            ];
        };
      };
    };
  };

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

  #ANCHOR Packages

  environment.systemPackages =
    (with pkgs; [
      #inputs.agenix.packages."${system}".default
      #(catppuccin-sddm.override {
      #  flavor = "mocha";
      #  font  = "Noto Sans";
      #  fontSize = "9";
      #  #background = "${./wallpaper.png}";
      #  loginBackground = true;
      #  })

      neovim
      nano
      wget
      curl
      google-chrome
      (chromium.override {enableWideVine = true;})
      floorp
      # System Packages
      baobab
      btrfs-progs
      clang
      duf
      eza
      ffmpeg
      glib #for gsettings to work
      gsettings-qt
      libappindicator
      openssl #required by Rainbow borders
      xdg-user-dirs
      xdg-utils
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
      fastfetch
      (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
      #ranger #Minimalistic/Terminal file manager

      #Games
      steam
      gamescope
      mangohud
      rare
      discord
      (discord.override {
        # remove any overrides that you don't want
        withOpenASAR = true;
        withVencord = true;
      })
      vesktop
      wine
      wine64
      wine-staging
      wine-wayland
      winetricks
      protontricks
      bottles
      gsmartcontrol

      #System tools
      gparted
      monitor
      putty
      htop
      remmina
      ethtool
      hwinfo
      wireshark
      ddclient
      vlc
      mpv
      pciutils
      kdePackages.kate
      fastfetch
      ghfetch
      screenfetch
      cpufetch
      ramfetch
      disfetch
      nix-index
      fetchutils
      #Manage Files as admin
      kdePackages.kio-admin
      lm_sensors
      netdata
      #Printing
      #cups-filters
      #cups-printers
      #canon-cups-ufr2
      #cups-bjnp

      #Torrenting
      #qbittorrent
      #miru #Streaming torrents

      #Vulkan
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools

      #Windows VM or Filesystem compatiblity
      qemu
      exfatprogs
      #Related to Virtualisation in settings
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      podman-desktop
      #docker-compose   # start group of containers for dev
      podman-compose # start group of containers for dev

      #Productivity / Video things
      (wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-pipewire-audio-capture
          obs-vkcapture
          obs-multi-rtmp
          obs-source-clone
          obs-source-record
          obs-source-switcher
          obs-websocket
          waveform
          obs-vaapi
          obs-teleport
          obs-scale-to-sound
          #obs-nvfbc
          obs-move-transition
          obs-command-source
          input-overlay
          #droidcam-obs
          obs-composite-blur
        ];
      })

      handbrake

      #davinci-resolve-studio

      #Coding
      gitFull
      gh
      vscode-fhs
      direnv
      python3Full
      python312Packages.pip
      virtualenv
      docker
      obsidian
      libei
      libportal
      #Twitch
      #chatterino2  #Chatterino without 7tv stuff
      chatterino7 #Chatterino with 7tv stuff

      #Misc
      spotify
      nvtopPackages.nvidia
      tailscale
      jq
      qdirstat
      service-wrapper
      #autokey          #Doesn't work with Wayland
      ntfs3g #FUSE-based NTFS driver with full write support
      nvd #Nix/NixOS package version diff tool
      #p7zip            #
      rpi-imager #Raspberry Pi Imaging Utility
      #xclicker         #Doesn't work with Wayland
      #Calculators
      kdePackages.kcalc
      #coppwr           #Interesting, but not very useful to me
      pwvucontrol #Pipewire Volume Control
      dmidecode #System BIOS checker

      libsForQt5.kde-gtk-config
      libsForQt5.breeze-qt5
      libsForQt5.breeze-gtk
      libsForQt5.qt5ct
      libsForQt5.breeze-icons
      libsForQt5.oxygen
      #kdePackages.neochat (Insecure Dependancy warning?)

      furmark

      #School
      beekeeper-studio
      #onedrivegui
      #Libreoffice
      libreoffice
      hunspell
      hunspellDicts.en_US
      hunspellDicts.en-us

      # Hyprland Stuff
      #ags #V2 ags was released
      ags_1
      btop
      brightnessctl # for brightness control
      cava
      #cliphist
      eog
      gnome-system-monitor
      #file-roller
      gtk-engine-murrine #for gtk themes
      hypridle # requires unstable channel
      imagemagick
      inxi
      libsForQt5.qtstyleplugin-kvantum #kvantum
      nwg-look # requires unstable channel
      nvtopPackages.full
      pamixer
      pavucontrol
      playerctl
      pyprland
      qt6ct
      qt6.qtwayland
      qt6Packages.qtstyleplugin-kvantum #kvantum
      swappy
      unzip
      wallust
      wlogout
      yad
      yt-dlp

      (pkgs.hyprland.override {
        # or inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland
        #enableXWayland = true;  # whether to enable XWayland
        #legacyRenderer = false; # whether to use the legacy renderer (for old GPUs)
        withSystemd = true; # whether to build with systemd support
      })

      #Hyperland  #https://www.youtube.com/watch?v=61wGzIv12Ds
      xorg.xlsclients #Check if running with xwayland
      #Terminals
      kitty
      #Alternatives
      #alacritty
      #wezterm

      #Screenshots
      hyprshot
      grim
      slurp
      wl-clipboard

      meson
      waybar
      (
        pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
        })
      )
      #eww
      dunst
      #mako
      libnotify
      swaynotificationcenter
      networkmanagerapplet
      #Wallpaper Daemons
      #hyprpaper
      #swaybg
      #wpaperd
      #mpvpaper
      swww
      #App Launcher
      #most popular
      rofi-wayland
      #gtk rofi
      #wofi
      #Wiki also suggests
      bemenu
      #fuzzel
      #tofi

      #Polkit agent
      polkit
      #libsForQt5.polkit-qt
      #kdePackages.polkit-qt-1
      #libsForQt5.polkit-kde-agent
      #kdePackages.polkit-kde-agent-1
      #polkit_gnome #Do I need this?

      hyprcursor # requires unstable channel

      #check if running via xwayland or wayland
      #xorg.xwininfo

      #Bluetooth
      #blueman
      overskride

      #Compilers
      #gcc
      #clang
      #nvc
      #glib
      #glibc #NFS Most Wanted needed this?
      #cmake
      #pkg-config

      #Libraries
      libsecret
      egl-wayland

      dialog #makes certain things work within terminal

      busybox

      ventoy-full

      nixos-generators

      filezilla

      zoom-us

      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      adwaita-icon-theme

      cyberchef #Cyber Swiss Army Knife for encryption, encoding, compression and data analysis

      streamlink #Pipe Twtich into something like VLC

      file-roller #Appears to have better compatibility with more zip file types.

      gomtree #File system validation

      meld #Visual diff and merge tool

      quickemu #Quickly create and run optimized virtual machines

      testdisk #Data recovery utilities

      easyeffects #Audio effects for PipeWire applications
    ])
    ++ [
      python-packages
    ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          #Experimental = true;
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
    #Allow VNC and Synergy through firewall
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

  lib.mkMerge = {i18n.supportedLocales = ["all"];};

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

  #ANCHOR Services

  services = {
    desktopManager.plasma6.enable = true;
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      settings.X11Forwarding = false;
    };

    pulseaudio = {
      enable = false;
      package = pkgs.pulseaudioFull;
    };

    flatpak.enable = true;

    dbus.enable = true;

    tailscale = {
      enable = true;
      openFirewall = true;
      extraSetFlags = [
        "--advertise-exit-node"
      ];
      useRoutingFeatures = "both";
    };

    envfs.enable = true;

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
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      extraConfig = {
      };
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
                    #1"bluez5.auto-connect" = "[a2dp_sink]"
                    #"device.profile" = "a2dp-sink";
                  };
                };
              }
            ];
          };
        };
      };
    };

    #Auto CPU Freq
    #auto-cpufreq.enable = true;
    # Fwupd # Firmware updater
    #fwupd = {
    #  enable = true;
    #};
    #Printing
    #TODO: look into gutenprint and brlaser and/or pkgs.brgenml1lpr and pkgs.brgenml1cupswrapper for brother printers)
    #LINK: https://askubuntu.com/questions/1090410/16-04-how-do-i-install-canon-pixma-mg3620-driver
    #printing.enable = true;
    #avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    #};

    #Hyprland
    hypridle.enable = true;

    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
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

    upower.enable = lib.mkForce true;

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    #onedrive.enable = true;

    #btrfs.autoScrub = {
    #  enable = true;
    #  interval = "weekly";
    #  fileSystems = ["/"];
    #};

    samba = {
      enable = true;
      openFirewall = true;
    };
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
      "root"
      "greeter"
      "gamemode"
      "seat" #do I need this?
    ];
  };

  #ANCHOR Programs

  programs = {
    #Hyprland
    hyprland = {
      enable = true;
      #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdphls
      xwayland.enable = true;
      withUWSM = true;
    };
    waybar.enable = true;
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
      #clean.enable = true;
      #clean.extraArgs = "--keep-since 4d --keep 3";
      #flake = "";
    };

    #KDE window borders fix
    dconf.enable = true;
    #fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        #steamtinkerlaunch
      ];
      gamescopeSession.enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };

    #Virtualization (Windows VM) #TODO: move to it's own module (unsure if laptop will ever do some kind of Windows VM stuff, might just RDP/Parsec/VNC into it.)
    virt-manager.enable = true;

    #TODO: (Research) Something coding related (VS code talks about it)
    direnv.enable = true;

    nix-ld = {
      enable = true;
      #libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    };

    thunderbird = {
      enable = true;
      preferencesStatus = "user";
    };

    gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          renice = 10;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };
  };

  fonts = {
    #Fonts support
    enableDefaultPackages = true;

    packages = with pkgs;
      [
        noto-fonts
        noto-fonts-emoji
        fira-code
        jetbrains-mono
        terminus_font
        font-awesome
        source-han-sans
        source-han-sans-japanese
        source-han-serif-japanese
        vistafonts
        corefonts
        carlito
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
        serif = ["Noto Serif" "Source Han Serif"];
        sansSerif = ["Noto Sans" "Source Han Sans"];
      };
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
      #https://www.reddit.com/r/NixOS/comments/177wcyi/comment/k4vok4n
    };
    spiceUSBRedirection.enable = true;

    # Enable common container config files in /etc/containers
    containers = {
      enable = true;
    };
    #Podman https://nixos.wiki/wiki/Podman
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.spice-vdagentd.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      #xdg-desktop-portal-gtk
      #xdg-desktop-portal-kde
    ];
    xdgOpenUsePortal = true;
  };

  qt = {
    enable = true;
    style = "breeze";
    platformTheme = "kde";
  };

  security = {
    pam = {
      services = {
        swaylock = {
          text = ''
            auth include login
          '';
        };
      };
    };
    rtkit.enable = true;

    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  documentation.nixos.enable = false;

  #home-manager.useGlobalPkgs = true;
  #home-manager.useUserPackages = true;
  #home-manager.users.ajhyperbit = { imports = [ ./config/home.nix ];};
  #home-manager.extraSpecialArgs = {inherit inputs self username;};
  #home-manager.backupFileExtension = "hm-bak";

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
}
