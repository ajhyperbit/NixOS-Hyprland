#TODO Breakup more into respective files
{...}: {
  #ANCHOR Services

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

    #Auto CPU Freq
    #auto-cpufreq.enable = true;
    # Fwupd # Firmware updater
    #fwupd = {
    #  enable = true;
    #};
    #Printing
    #TODO: look into gutenprint and brlaser and/or pkgs.brgenml1lpr and pkgs.brgenml1cupswrapper for brother printers)
    #LINK: https://askubuntu.com/questions/1090410/16-04-how-do-i-install-canon-pixma-mg3620-driver
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

    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    onedrive.enable = true;

    #asusd = {
    #  enable = true;
    #};
  };
}
