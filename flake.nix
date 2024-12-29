# 💫 https://github.com/JaKooLit 💫 #

{

  description = "NixOS configuration";

  inputs = {
  	nixpkgs.url = "nixpkgs/nixos-unstable";
	#wallust.url = "git+https://codeberg.org/explosion-mental/wallust?ref=dev";
	hyprland.url = "github:hyprwm/Hyprland"; # hyprland development
	distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes"; 
  	};

  outputs = 
	inputs@{ self,nixpkgs, ... }:
    	let
      system = "x86_64-linux";
      host = "nixos";
      #host = "nixtop";
      username = "ajhyperbit";

    pkgs = import nixpkgs {
       	inherit system;
       	config = {
       	allowUnfree = true;
       	};
      };
    in
      {
    nixosConfigurations = {
      "${host}" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
			  inherit system;
			  inherit inputs;
			  inherit username;
			  inherit host;
        inherit self;
        };
      modules = [
				./hosts/${host}/config.nix 
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ajhyperbit = { imports = [ ./config/home.nix ];};
          home-manager.extraSpecialArgs = {inherit inputs self username;};
          home-manager.backupFileExtension = "backup";
        }
        stylix.nixosModules.stylix
        #fufexan-dotfiles.packages.${system}.bibata-hyprcursor
        #fufexan-dotfiles.nixosModules.theme

        #nixos-vfio.nixosModules.vfio
        #nixos-hardware.nixosModules.framework-11th-gen-intel
        #wayland.windowManager.hyprland {
        #  enable = true;
        #  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        #}
      ];
      };
    };
  };
}
