#TODO Breakup more into respective files
{...}: {
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

    #coolercontrol.enable = true;

    #rog-control-center.enable = true;

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
}
