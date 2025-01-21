{...}: {
  nix = {
    settings = {
      #warn-dirty = false;
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org?priority=10"

        #"https://anyrun.cachix.org"
        #"https://fufexan.cachix.org"
        #"https://helix.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
        #"https://yazi.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

        #"anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        #"fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
        #"helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        #"yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 60d";
    };

    #extraOptions = ''
    #  !include ${config.age.secrets.nix-access-tokens-github.path}
    #'';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      #    allowUnfreePredicate = pkg: builtins.elem (builtins.parseDrvName pkg.name).name ["steam"];
      #    packageOverrides = pkgs: {
      #
      #      #Make unstable packages available
      #      unstable = import (fetchTarball {
      #        url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
      #        sha256 = "17pikpqk1icgy4anadd9yg3plwfrsmfwv1frwm78jg2rf84jcmq2";
      #      }) {config = { allowUnfree = true; };};
      #
      #      #old_chrome = import (fetchTarball {
      #      #  url = "https://github.com/nixos/nixpkgs/archive/f02fa2f654c7bcc45f0e815c29d093da7f1245b4.tar.gz";
      #      #  sha256 = "";
      #      #}) {config = { allowUnfree = true; };};
      #
      #  };

      overlays = [
        #  (self: super: {
        #    google-chrome = super.google-chrome.override {
        #      commandLineArgs =
        #        "--password-store=basic";
        #    };
        #  })
      ];

      packageOverrides = pkgs: {
        steam = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              libkrb5
              keyutils
              gamescope
              mangohud
            ];
        };
      };
    };
  };
}
