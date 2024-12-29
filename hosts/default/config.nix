# 💫 https://github.com/JaKooLit 💫 #
# Main default config


# NOTE!!! : Packages and Fonts are configured in packages-&-fonts.nix


{ config, pkgs, host, username, options, lib, inputs, system, ...}: let
  
  inherit (import ./variables.nix) keyboardLayout;
    
  in {
  imports = [
    ./hardware.nix
    ./users.nix
    ./packages-fonts.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    #../../modules/nvidia-prime-drivers.nix
    #../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  # BOOT related stuff
  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # Kernel

    kernelParams = [
    "systemd.mask=systemd-vconsole-setup.service"
    "systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
    "nowatchdog" 
    #"modprobe.blacklist=sp5100_tco" #watchdog for AMD
    #"modprobe.blacklist=iTCO_wdt" #watchdog for Intel
    "nohibernate"
    "amd_iommu=on"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    tmp.cleanOnBoot = true;
    #supportedFilesystems = ["ntfs"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      #grub = {
      #  device = "nodev";
      #  efiSupport = true;
      #  enable = true;
      #  useOSProber = true;
      #  timeoutStyle = "menu";
      #};
      #timeout = 300;
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
    
    plymouth.enable = true;  

  };

  drivers.nvidia.enable = true;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;


  nix = {
    settings = {
      #warn-dirty = false;
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [
        "https://nix-gaming.cachix.org" 
        "https://hyprland.cachix.org"
        ];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 60d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  
  programs = {
	  hyprland = {
      enable = true;
		  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
		  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdphls
  	  xwayland.enable = true;
      };

	
	  waybar.enable = true;
	  hyprlock.enable = true;
	  firefox.enable = true;
	  git.enable = true;
    nm-applet.indicator = true;
    #neovim.enable = true;

	  thunar.enable = true;
	  thunar.plugins = with pkgs.xfce; [
		  exo
		  mousepad
		  thunar-archive-plugin
		  thunar-volman
		  tumbler
  	  ];
	
    virt-manager.enable = false;
    
    #steam = {
    #  enable = true;
    #  gamescopeSession.enable = true;
    #  remotePlay.openFirewall = true;
    #  dedicatedServer.openFirewall = true;
    #};
    
    xwayland.enable = true;

    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
	
  };

  users = {
    mutableUsers = true;
  };

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
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

  #console = {
  #  packages = [pkgs.terminus_font];
  #  font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
  #  useXkbConfig = true;
  #};

  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      #Allow X11vnc through SSH. (probably unneccesary with tailscale)
      settings.X11Forwarding = true;
    };

    flatpak.enable = true;

    dbus.enable = true;

    #Different Compositor that might be conflicting
    #picom.enable = true;

    #gnome.gnome-keyring.enable = true;

    tailscale.enable = true;

    envfs.enable = true;

    #DDNS config
    ddclient = {
      enable = true;
      configFile = "/etc/ddclient/ddclient.conf";
    };

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
      enable = true;
      #windowManager.dwm.enable = true;
      videoDrivers = ["nvidia"];
      #Keyboard
      xkb = {
        layout = "us";
        variant = "";
      };


      desktopManager.plasma5.enable = true; 

      displayManager = {
        #x11VNC / VNC
        sessionCommands = ''
          ${pkgs.x11vnc}/bin/x11vnc -bg -reopen -forever -rfbauth $HOME/.vnc/passwd -display :0 &
        '';
      };
    };
        #These might have been renamed as well
        # Enable the GNOME Desktop Environment.
        #displayManager.gdm.enable = true;
        #desktopManager.gnome.enable = true;

        #services.desktopManager.plasma6.enable = true;
        #Plasma wayland stuff
        #services.displayManager.sddm.wayland.enable = true;
        #services.displayManager.defaultSession = "plasmawayland"; #uncomment to enable plasma wayland, recomment to enable plasma x11

        # Enable Pantheon Desktop
        #services.xserver.desktopManager.pantheon.enable = true;

        # Enable MATE Desktop
        #services.xserver.desktopManager.mate.enable = true;

        # Enable Cinnamon Desktop
        #services.xserver.desktopManager.cinnamon.enable = true;
        #services.cinnamon.apps.enable = true;

        #environment.systemPackages = [
        #  pkgs.cinnamon.cinnamon-common
        #];

        #From Chris Titus' configuration.nix
        #lightdm.enable = true;
        #setupCommands = ''
        #  ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal
        #'';
  
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

    #Auto CPU Freq
    #auto-cpufreq.enable = true;
    # Fwupd # Firmware updater
    fwupd = {
      enable = true;
    };
        #Printing 
        #TODO: look into gutenprint and brlaser and/or pkgs.brgenml1lpr and pkgs.brgenml1cupswrapper for brother printers)
        #TODO: add this link into a future compiled file https://askubuntu.com/questions/1090410/16-04-how-do-i-install-canon-pixma-mg3620-driver
        #TODO: break up printing into it's own printing.nix?
        #TODO: revert once updated so not vulnerable to lots of 2024 CVEs at least one of which is a 9.9
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

	  upower.enable = true;

  };
  

  #NOTE: From Chris Titus' configuration.nix
  #nixpkgs.overlays = [
  #  (final: prev: {
  #    dwm = prev.dwm.overrideAttrs (old: {src = /home/${user}/CTT-Nix/system/dwm-titus;}); #FIX ME: Update with path to your dwm folder
  #  })
  #];

  #NOTE: From Chris Titus' configuration.nix
  #users.users.titus = {
  #  isNormalUser = true;
  #  description = "Titus";
  #  extraGroups = [
  #    "flatpak"
  #    "disk"
  #    "qemu"
  #    "kvm"
  #    "libvirtd"
  #    "sshd"
  #    "networkmanager"
  #    "wheel"
  #    "audio"
  #    "video"
  #    "libvirtd"
  #    "root"
  #  ];
  #};

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
    ];
  };

  programs ={
    
    #Hyprland
	  hyprland = {
      enable = true;
		  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
		  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdphls
  	  xwayland.enable = true;
      };
	  waybar.enable = true;
	  hyprlock.enable = true;
	  firefox.enable = true;
	  git.enable = true;

    thunar.enable = true;
	  thunar.plugins = with pkgs.xfce; [
		  exo
		  mousepad
		  thunar-archive-plugin
		  thunar-volman
		  tumbler
  	  ];

    #KDE window borders fix
    dconf.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      extraCompatPackages = with pkgs; [
      proton-ge-bin
      steamtinkerlaunch
      ];
    };

    #Virtualization (Windows VM) #TODO: move to it's own module (unsure if laptop will ever do some kind of Windows VM stuff, might just RDP/Parsec/VNC into it.)
    virt-manager.enable = true;

    #seahorse.enable = true;
    #Workaround for error: "The option `programs.ssh.askPassword' has conflicting definition values:"
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
      libraries = pkgs.steam-run.fhsenv.args.multiPkgs pkgs;
    };
  };


  environment= {
    #shellAliases = {
    #  google-chrome = "google-chrome-stable"
    #};
    variables = {
      #QT_STYLE_OVERRIDE = "breeze";
      #QT_QPA_PLATFORMTHEME= "qt5ct";
    };

    sessionVariables = {
    no_hardware_cursors = "true";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    KDE_FULL_SESSION = "true";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    #QT_QPA_PLATFORMTHEME= "qt5ct";
  };
  };

  fonts = {
    #Fonts support 
    enableDefaultPackages = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      fira-code
      jetbrains-mono
      terminus_font
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      nerdfonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
        serif = ["Noto Serif" "Source Han Serif"];
        sansSerif = ["Noto Sans" "Source Han Sans"];
      };
     };
    };

  #Virtualisation
  virtualisation = {
    libvirtd.enable = true;
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
      ];
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

  #TODO: I dunno (research later?) (still don't know, keeping it anyway)
  qt = {
    enable = true;
    style = "breeze";
    platformTheme = "kde";
  };

  security = {
    pam = {
      services = {
        sddm.kwallet.enable = true;
        #login.kwallet.enable = true;
        kde.kwallet.enable = true;
        hyprland.kwallet.enable = true;
        #sddm.enableGnomeKeyring = true;
        #login.enableGnomeKeyring = true;
        #kde.enableGnomeKeyring = true;
        #hyprland.enableGnomeKeyring = true;
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
  # Microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  #Sleep settings
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  documentation.nixos.enable = false;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
    services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  };

  # zram
  zramSwap = {
	  enable = true;
	  priority = 100;
	  memoryPercent = 30;
	  swapDevices = 1;
    algorithm = "zstd";
    };

  powerManagement = {
  	enable = true;
	  cpuFreqGovernor = "schedutil";
  };

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };



  #systemd = {
  #  user.services.polkit = {
  #    description = "polkit";
  #    wantedBy = [ "graphical-session.target" ];
  #    wants = [ "graphical-session.target" ];
  #    after = [ "graphical-session.target" ];
  #    serviceConfig = {
  #        Type = "simple";
  #        ExecStart = "${pkgs.polkit}/libexec/polkit-gnome-authentication-agent-1";
  #        Restart = "on-failure";
  #        RestartSec = 1;
  #        TimeoutStopSec = 10;
  #      };
  #  };
  #};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
