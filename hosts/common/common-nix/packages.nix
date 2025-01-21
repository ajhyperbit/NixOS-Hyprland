{...}: {
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

      #TODO Refactor

      neovim
      #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      google-chrome
      #chromium
      (chromium.override {enableWideVine = true;})
      floorp
      # System Packages
      baobab
      btrfs-progs
      clang
      curl
      #cpufrequtils
      duf
      eza
      ffmpeg
      glib #for gsettings to work
      gsettings-qt
      #killall
      libappindicator
      openssl #required by Rainbow borders
      xdg-user-dirs
      xdg-utils
      fastfetch
      (mpv.override {scripts = [mpvScripts.mpris];}) # with tray
      #ranger

      #Games
      steam
      #Epic Games
      #heroic
      gamescope
      mangohud
      #steamtinkerlaunch
      rare
      #protonup-qt
      #For Need for Speed Most Wanted
      glibc
      discord
      (discord.override {
        # remove any overrides that you don't want
        withOpenASAR = true;
        withVencord = true;
      })
      vesktop #for sharing audio on discord, since normal discord has
      wine
      wine64
      wine-staging
      wine-wayland
      winetricks
      #playonlinux
      protontricks
      bottles
      #(lutris.override {
      #  extraPkgs = pkgs: [
      #    # List package dependencies here
      #    wineWowPackages.stable
      #    winetricks
      #  ];
      #})
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
      #cinnamon.nemo-with-extensions
      vlc
      mpv
      xdotool
      pciutils
      kdePackages.kate
      #libsForQt5.sddm-kcm
      #libsForQt5.kwin
      neofetch
      fastfetch
      ghfetch
      screenfetch
      cpufetch
      ramfetch
      disfetch
      nix-index
      fetchutils
      #Antivirus GUI
      #clamtk
      #Password things
      #pass
      #keepassxc
      #Manage Files as admin
      kdePackages.kio-admin
      lm_sensors
      netdata
      #fanctl
      #Printing #TODO: revert once updated so not vulnerable to lots of 2024 CVEs at least one of which is a 9.9
      #cups-filters
      #cups-printers
      #canon-cups-ufr2
      #cups-bjnp

      #Torrenting
      #qbittorrent
      miru

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
      #docker-compose # start group of containers for dev
      podman-compose # start group of containers for dev

      #Productivity / Video things
      (wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          #obs-backgroundremoval
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
          obs-nvfbc
          #obs-ndi
          obs-move-transition
          obs-command-source
          input-overlay
          #advanced-scene-switcher
          droidcam-obs
          obs-composite-blur
        ];
      })

      handbrake

      #davinci-resolve-studio

      #Coding
      gitFull
      #gittyup
      gh
      vscode-fhs
      #alejandra
      #quickemu
      #quickgui
      direnv
      python3Full
      python312Packages.pip
      virtualenv
      docker
      #nodejs_22
      obsidian
      #synergy

      #Twitch
      chatterino2

      #Misc
      spotify
      parsec-bin
      unrar
      zenith-nvidia
      clinfo
      gwe
      nvtopPackages.nvidia
      tailscale
      parsec-bin
      jq
      qdirstat
      service-wrapper
      autokey
      ntfs3g
      nvd
      p7zip
      rpi-imager
      xclicker
      #Calculators
      kdePackages.kcalc
      #qalculate-qt
      #lastpass-cli
      dconf2nix
      coppwr
      pwvucontrol
      dmidecode

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
      onedrivegui
      #Libreoffice
      libreoffice-qt
      hunspell
      hunspellDicts.en_US
      hunspellDicts.en-us

      #Makes other distros available to me
      #distrobox

      # Hyprland Stuff
      (ags.overrideAttrs (oldAttrs: {
        inherit (oldAttrs) pname;
        version = "1.8.2";
      }))
      #ags
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
      polkit_gnome

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
      #cmake
      #pkg-config

      #Libraries
      libsecret
      egl-wayland

      #gobject-introspection
      #dbus-glib
      #gtk4
      #gtk3
      #gjs
      #libpulseaudio
      #pam
      #typescript
      #ninja
      #axel
      #tinyxml-2

      dialog #makes certain things work within terminal

      busybox

      ventoy-full

      nixos-generators

      filezilla
    ])
    ++ [
      python-packages
    ];

}
