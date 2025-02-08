#{
#  config,
#  pkgs,
#  options,
#  ...
#}:
#let
#  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
#  state = system.stateVersion
#in
#{
#  imports = [
#    (import "${home-manager}/nixos")
#  ];
#
#  home-manager.users.ajhyperbit = {
#    /* The home.stateVersion option does not have a default and must be set */
#    home.stateVersion = "${state}";
#    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
#  };
#}
#Enable Git
#programs.git = {
#  package = pkgs.gitFull;
#  enable = true;
#  userName = "ajhyperbit";
#  userEmail = "ajhyperbit@gmail.com"
#};
{
  config,
  pkgs,
  options,
  username,
  lib,
  stateVersion-hm,
  ...
}: {
  imports = [
  ];

  fonts.fontconfig.enable = true;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    packages = with pkgs; [
    ];
    stateVersion = lib.mkDefault "${stateVersion-hm}";
  };

  stylix = {
    #enable = true;
    autoEnable = true; #default is true
    polarity = "dark";
    cursor = {
      name = "Oxygen-Zion";
      package = pkgs.oxygen;
      size = 24;
    };
  };

  xdg = {
    #  enable = true;
    #  userDirs = {
    #    enable = true;
    #    createDirectories = true;
    #  };
    #configFile = {
    #  "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    #  "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    #  "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    #};
  };

  #gtk = {
  #  enable = true;
  #  theme = {
  #    #name = "Nordic";
  #    name = "Breeze-Dark";
  #    #name = "kvantum-dark";
  #    #package = pkgs.nordic;
  #    package = pkgs.libsForQt5.breeze-gtk;
  #    #package = pkgs.kvantum;
  #  };
  #  iconTheme = {
  #    name = "breeze-dark";
  #    package = pkgs.libsForQt5.breeze-icons;
  #  };
  #  cursorTheme = {
  #    name = "Oxygen-Zion";
  #    package = pkgs.oxygen;
  #    size = 24;
  #  };
  #
  #  gtk2 = {
  #    configLocation = "${config.home.homeDirectory}/.gtkrc-2.0";
  #  };
  #
  #  gtk3.extraConfig = {
  #    gtk-application-prefer-dark-theme=1;
  #  };
  #
  #  gtk4.extraConfig = {
  #    gtk-application-prefer-dark-theme=1;
  #  };
  #
  #};

  #dconf = {
  #  settings = {
  #    "org/gnome/desktop/interface" = {
  #      gtk-theme = "${config.gtk.theme.name}";
  #      #cursor-theme = "${config.gtk.cursorTheme.name}";
  #      color-scheme = "prefer-dark";
  #    };
  #    "org/gnome/desktop/wm/preferences" = {
  #      theme = "${config.gtk.theme.name}";
  #    };
  #  };
  #};
}
