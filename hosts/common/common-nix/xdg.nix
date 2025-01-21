{...}: {
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

  #XDG Portals
  #xdg = {
  #  #autostart.enable = true;
  #  portal = {
  #    enable = true;
  #    wlr.enable = true;
  #    extraPortals = with pkgs; [
  #      #xdg-desktop-portals
  #      #xdg-desktop-portal-kde
  #      #xdg-desktop-portal-gtk
  #    ];
  #    xdgOpenUsePortal = true;
  #  configPackages = [
  #    #pkgs.xdg-desktop-portal-gtk
  #    #pkgs.xdg-desktop-portal
  #  ];
  #
  #  config = {
  #  #  common = {
  #  #    default = [
  #  #      "kde"
  #  #      ];
  #  #  };
  #    #"org.freedesktop.impl.portal.FileChooser"= [
  #    #  "kde"
  #    #    ];
  #  };
  #  };
  #};
}
