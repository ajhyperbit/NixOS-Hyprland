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

  home.file = {
    #LINK - https://github.com/nix-community/home-manager/commit/91551c09d48583230b36cf759ad703b5f1d83d9a
    "/.config/ags".source = config.lib.file.mkOutOfStoreSymlink ../../config/ags;
    #"/.config/btop".source = config.lib.file.mkOutOfStoreSymlink ../../config/btop; #Changes made to this on the fly is an issue
    "/.config/cava".source = config.lib.file.mkOutOfStoreSymlink ../../config/cava;
    "/.config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink ../../config/fastfetch;
    #"/.config/hypr".source = config.lib.file.mkOutOfStoreSymlink ../../config/hypr;
    "/.config/kitty".source = config.lib.file.mkOutOfStoreSymlink ../../config/kitty;
    "/.config/Kvantum".source = config.lib.file.mkOutOfStoreSymlink ../../config/Kvantum;
    "/.config/nvim".source = config.lib.file.mkOutOfStoreSymlink ../../config/nvim;
    "/.config/qt5ct".source = config.lib.file.mkOutOfStoreSymlink ../../config/qt5ct;
    "/.config/qt6ct".source = config.lib.file.mkOutOfStoreSymlink ../../config/qt6ct;
    "/.config/rofi".source = config.lib.file.mkOutOfStoreSymlink ../../config/rofi;
    "/.config/swappy".source = config.lib.file.mkOutOfStoreSymlink ../../config/swappy;
    "/.config/swaync".source = config.lib.file.mkOutOfStoreSymlink ../../config/swaync;
    "/.config/Thunar".source = config.lib.file.mkOutOfStoreSymlink ../../config/Thunar;
    "/.config/wallust".source = config.lib.file.mkOutOfStoreSymlink ../../config/wallust;
    "/.config/waybar".source = config.lib.file.mkOutOfStoreSymlink ../../config/waybar;
    "/.config/wlogout".source = config.lib.file.mkOutOfStoreSymlink ../../config/wlogout;

    #"/.config/xfce4".source = config.lib.file.mkOutOfStoreSymlink ../../assets/xfce4;
  };

  #LINK - https://discourse.nixos.org/t/how-to-manage-dotfiles-with-home-manager/30576
  #LINK - https://home-manager-options.extranix.com/?query=xdg&release=release-24.05

  #LINK - https://github.com/nix-community/home-manager/issues/2085#issuecomment-2022239332

  #options = {
  #  dotfiles = lib.mkOption {
  #    type = lib.types.path;
  #    apply = toString;
  #    default = "${config.home.homeDirectory}/NixOS-Hyprland";
  #    #example = "${config.home.homeDirectory}/NixOS-Hyprland";
  #    description = "Location of the dotfiles working copy";
  #  };
  #};

  #xdg.configFile."ags".source = config.lib.file.mkOutOfStoreSymlink "${options.dotfiles}/config/ags";

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
}
