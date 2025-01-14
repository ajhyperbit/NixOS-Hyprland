{
  config,
  pkgs,
  options,
  username,
  lib,
  stateVersion-host-iso,
  ...
}: {
  imports = [
  ];

  fonts.fontconfig.enable = true;

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "${stateVersion-host-iso}";
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
}
