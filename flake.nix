{

  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      #url = "github:nix-community/home-manager/release-24.05";
      url = "github:nix-community/home-manager"; #unstable / master(?)
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";

    #nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix.url = "github:danth/stylix";

    #nixos-vfio.url = "github:j-brn/nixos-vfio";
    #inputs.flake-compat = {
    #  url = "github:edolstra/flake-compat";
    #  flake = false;
    #};
  };

outputs = inputs@{
  self,
  nixpkgs,
  home-manager,
  stylix,
  #nixos-vfio,
  #nixos-hardware,
  ...
  }:
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
