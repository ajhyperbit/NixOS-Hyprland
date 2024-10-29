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


{config, pkgs, options, username, ...}: {
  
  imports = [
    ./packages
  ];

  fonts.fontconfig.enable = true;

  #xdg = {
  #  enable = true;
  #  userDirs = {
  #    enable = true;
  #    createDirectories = true;
  #  };
  #};

  gtk = {
    enable = true;

    gtk.theme.package = pkgs.nordic;
    gtk.theme.name = "nordic";
  };
  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";

    packages = with pkgs; [

    ];
  };
}
