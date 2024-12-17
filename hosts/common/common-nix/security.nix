{...}: {
  security = {
    pam = {
      services = {
        sddm.kwallet.enable = true;
        #login.kwallet.enable = true;
        kde.kwallet.enable = true;
        hyprland.kwallet.enable = true;
        #sddm.enableGnomeKeyring = true;
        #login.enableGnomeKeyring = true;
        #kde.enableGnomeKeyring = true;
        #hyprland.enableGnomeKeyring = true;
        swaylock = {
          text = ''
            auth include login
          '';
        };
      };
    };
    rtkit.enable = true;

    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
  };
}
