{...}: {
  systemd = {
    #user.services.polkit-gnome-authentication-agent-1 = {
    #  description = "polkit-gnome-authentication-agent-1";
    #  wantedBy = ["graphical-session.target"];
    #  wants = ["graphical-session.target"];
    #  after = ["graphical-session.target"];
    #  serviceConfig = {
    #    Type = "simple";
    #    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #    Restart = "on-failure";
    #    RestartSec = 1;
    #    TimeoutStopSec = 10;
    #  };
    #};
    services.flatpak-repo = {
      path = [pkgs.flatpak];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };

    services.NetworkManager-wait-online.enable = pkgs.lib.mkForce false;

    #Sleep settings
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
  };
}
