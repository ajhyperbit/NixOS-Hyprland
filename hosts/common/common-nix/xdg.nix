{...}: {
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
