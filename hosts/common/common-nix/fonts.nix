{...}: {
  fonts = {
    #Fonts support
    enableDefaultPackages = true;

    packages = with pkgs;
      [
        noto-fonts
        noto-fonts-emoji
        fira-code
        jetbrains-mono
        terminus_font
        font-awesome
        source-han-sans
        source-han-sans-japanese
        source-han-serif-japanese
        vistafonts
        corefonts
        carlito
      ]
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
        serif = ["Noto Serif" "Source Han Serif"];
        sansSerif = ["Noto Sans" "Source Han Sans"];
      };
    };
  };
}
