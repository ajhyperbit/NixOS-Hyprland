# 💫 https://github.com/JaKooLit 💫 #
{
  description = "AJ's NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    #nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    #nixpkgs-staging.url = "nixpkgs/staging";

    home-manager = {
      #url = "github:nix-community/home-manager/release-24.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      #url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #Secureboot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "github:edolstra/flake-compat";

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    distro-grub-themes.url = "github:AdisonCavani/distro-grub-themes";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    stylix.url = "github:danth/stylix";

    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fw-fanctrl = {
      url = "github:TamtamHero/fw-fanctrl/packaging/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    #nixos-vfio.url = "github:j-brn/nixos-vfio";

    nix-alien.url = "github:thiagokokada/nix-alien";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    stylix,
    alejandra,
    nixos-hardware,
    fw-fanctrl,
    agenix,
    #nixpkgs-staging,
    lanzaboote,
    nix-alien,
    nixos-generators,
    ...
  }: let
    system = "x86_64-linux";
    host = "nixos";
    laptop-host = "nixtop";
    iso = "iso";
    nixserver = "nixserver";
    username = "ajhyperbit";
    home = "/home/ajhyperbit";
    stateVersion-host = "23.11";
    #This is due to the fact home manager got installed on 24.05 and NOT 23.11.
    #I am prioritizing keeping stateVersion accurate across files and preventing breakage,
    #but upon a reinstall or a requirement of bumping stateVersion I will try to change this
    #so stateVersion-host and stateVersion-hm can be the same so stateVersion-hm can be removed
    stateVersion-hm = "24.05";
    stateVersion-host-iso = "25.05";

    #Learned patching from here
    #LINK: https://discourse.nixos.org/t/proper-way-of-applying-patch-to-system-managed-via-flake/21073/26

    #overlay-staging = final: prev: {
    #  staging = import nixpkgs-staging {
    #    inherit system;
    #    config.allowUnfree = true;
    #  };
    #};

    #NOTE: If patches are required

    #pkgs-init = import inputs.nixpkgs {inherit system;};

    #patches = [
    #  (pkgs-init.fetchpatch {
    #    #url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/.patch";
    #    #hash = "sha256-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=";
    #    #url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/368882.patch";
    #    #hash = "sha256-u8eqXLYijsgQJ1Nk0w05eCdA/yYzOvyP93dFxEuHo30=";
    #  })
    #];

    #nixpkgs-patched = pkgs-init.applyPatches {
    #  name = "nixpkgs-patched";
    #  src = inputs.nixpkgs;
    #  inherit patches;
    #};

    #pkgs = import nixpkgs-patched {
    #  inherit system;
    #  config = {
    #    allowUnfree = true;
    #  };
    #  #overlays = [xdphOverlay];
    #};
    #nixpkgs = (import "${nixpkgs-patched}/flake.nix").outputs {self = inputs.self;};

    #LINK: https://github.com/NixOS/nix/issues/3920#issuecomment-806154862
    #NOTE: Trying to make an if-else clause if there are patches I want to apply to fix an issue would be nice
    #patchChannel = channel: patches:
    #  if patches == []
    #  then channel
    #  else
    #    (import channel {inherit system;}).pkgs.applyPatches
    #    {
    #      name = "nixpkgs-patched-${channel.shortRev}";
    #      src = channel;
    #      patches = patches;
    #    };

    #NOTE: If patches are not required
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    nixosModules.myFormats = {config, ...}: {
      imports = [
        nixos-generators.nixosModules.all-formats
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
    };

    nixosConfigurations = {
      # A single nixos config outputting multiple formats.
      # Alternatively put this in a configuration.nix.
      nixosModules.myFormats = {config, ...}: {
        imports = [
          nixos-generators.nixosModules.all-formats
        ];
      };
      #Main Desktop
      "${host}" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit username;
          inherit host;
          inherit home;
          inherit self;
          #inherit pkgs;
          inherit stateVersion-host;
          inherit stateVersion-hm;
        };
        modules = [
          ./hosts/${host}/config.nix
          ./hosts/${host}/hardware.nix
          ./hosts/${host}/drives.nix
          ./hosts/common/common.nix
          ./hosts/common/users.nix
          ./modules/nvidia-drivers.nix
          ./modules/vm-guest-services.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ajhyperbit = {
              imports = [
                ./hosts/common/home.nix
                ./hosts/${host}/home.nix
              ];
            };
            home-manager.extraSpecialArgs = {inherit inputs self username stateVersion-hm;};
            home-manager.backupFileExtension = "backup";
          }

          stylix.nixosModules.stylix

          agenix.nixosModules.default

          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }

          (
            {pkgs, ...}: {
              environment.systemPackages = [
              ];
            }
          )

          ({
            self,
            system,
            ...
          }: {
            environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
              nix-alien
            ];
          })

          #({
          #  config,
          #  pkgs,
          #  ...
          #}: {nixpkgs.overlays = [overlay-staging];}
          #)

          #fufexan-dotfiles.packages.${system}.bibata-hyprcursor
          #fufexan-dotfiles.nixosModules.theme

          #nixos-vfio.nixosModules.vfio
          #wayland.windowManager.hyprland {
          #  enable = true;
          #  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          #}
        ];
      };
      #Framework13
      "${laptop-host}" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit username;
          inherit laptop-host;
          inherit home;
          inherit self;
          inherit stateVersion-host;
          inherit stateVersion-hm;
        };
        modules = [
          ./hosts/${laptop-host}/config.nix
          ./hosts/${laptop-host}/hardware.nix
          ./hosts/common/common.nix
          ./hosts/common/users.nix
          ./modules/intel-drivers.nix
          nixos-hardware.nixosModules.framework-11th-gen-intel
          home-manager.nixosModules.home-manager
          fw-fanctrl.nixosModules.default
          #lanzaboote.nixosModules.lanzaboote #Secureboot
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ajhyperbit = {
              imports = [
                ./hosts/common/home.nix
                ./hosts/${laptop-host}/home.nix
              ];
            };
            home-manager.extraSpecialArgs = {inherit inputs self username stateVersion-hm;};
            home-manager.backupFileExtension = "backup";
          }
          stylix.nixosModules.stylix

          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }

          (
            {
              pkgs,
              lib,
              ...
            }: {
              environment.systemPackages = [
              ];

              #boot.loader.systemd-boot.enable = lib.mkForce false;

              #boot.lanzaboote = {
              #  enable = true;
              #  pkiBundle = "var/lib/sbctl";
              #};
            }
          )

          ({
            self,
            system,
            ...
          }: {
            environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
              nix-alien
            ];
          })
        ];
      };
      #Yet to be built server (someday)
      #"${nixserver}" = nixpkgs.lib.nixosSystem rec {
      #  system = "x86_64-linux";
      #  specialArgs = {
      #    inherit system;
      #    inherit inputs;
      #    inherit username;
      #    inherit nixserver;
      #    inherit self;
      #  };
      #  modules = [
      #    ./hosts/${nixserver}/config.nix
      #    ./hosts/${nixserver}/hardware.nix
      #    ./hosts/server/server.nix
      #    ./hosts/common/users.nix
      #    home-manager.nixosModules.home-manager
      #    {
      #      home-manager.useGlobalPkgs = true;
      #      home-manager.useUserPackages = true;
      #      home-manager.users.ajhyperbit = {imports = [./config/home.nix];};
      #      home-manager.extraSpecialArgs = {inherit inputs self username;};
      #      home-manager.backupFileExtension = "backup";
      #    }
      #    stylix.nixosModules.stylix
      #    ({pkgs, ...}: {
      #      environment.systemPackages = [
      #      ];
      #    })
      #  ];
      #};

      #NOTE - Build with "nix build .#nixosConfigurations.iso.config.system.build.isoImage"
      #${iso} = nixpkgs.lib.nixosSystem rec {
      #  system = "x86_64-linux";
      #  specialArgs = {
      #    inherit system;
      #    inherit inputs;
      #    inherit username;
      #    inherit laptop-host;
      #    inherit home;
      #    inherit self;
      #    inherit stateVersion-host;
      #    inherit stateVersion-hm;
      #  };
      #  modules = [
      #    ./hosts/${laptop-host}/config.nix
      #    ./hosts/${laptop-host}/hardware.nix
      #    ./hosts/common/common.nix
      #    ./hosts/common/users.nix
      #    ./modules/intel-drivers.nix
      #    nixos-hardware.nixosModules.framework-11th-gen-intel
      #    home-manager.nixosModules.home-manager
      #    fw-fanctrl.nixosModules.default
      #    #lanzaboote.nixosModules.lanzaboote #Secureboot
      #    {
      #      home-manager.useGlobalPkgs = true;
      #      home-manager.useUserPackages = true;
      #      home-manager.users.ajhyperbit = {
      #        imports = [
      #          ./hosts/common/home.nix
      #          ./hosts/${laptop-host}/home.nix
      #        ];
      #      };
      #      home-manager.extraSpecialArgs = {inherit inputs self username stateVersion-hm;};
      #      home-manager.backupFileExtension = "backup";
      #    }
      #    stylix.nixosModules.stylix
      #
      #    {
      #      environment.systemPackages = [alejandra.defaultPackage.${system}];
      #    }
      #
      #    (
      #      {
      #        pkgs,
      #        lib,
      #        modulesPath,
      #        ...
      #      }: {
      #        imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
      #        environment.systemPackages = [
      #        ];
      #
      #        #boot.loader.systemd-boot.enable = lib.mkForce false;
      #
      #        #boot.lanzaboote = {
      #        #  enable = true;
      #        #  pkiBundle = "var/lib/sbctl";
      #        #};
      #      }
      #    )
      #
      #    ({
      #      self,
      #      system,
      #      ...
      #    }: {
      #      environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
      #        nix-alien
      #      ];
      #    })
      #  ];
      #};

      #NOTE - build with "nixos-generate --flake ~/NixOS-Hyprland#laptopiso -f iso"

      laptopiso = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit username;
          inherit laptop-host;
          inherit home;
          inherit self;
          inherit stateVersion-host-iso;
        };
        system = "x86_64-linux";
        modules = [
          nixos-hardware.nixosModules.framework-11th-gen-intel
          home-manager.nixosModules.home-manager
          fw-fanctrl.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ajhyperbit = {
              imports = [
                ./hosts/iso/home.nix
              ];
            };
            home-manager.extraSpecialArgs = {inherit inputs self username stateVersion-host-iso;};
            home-manager.backupFileExtension = "backup";
          }
          self.nixosModules.myFormats
          stylix.nixosModules.stylix
          (
            {
              pkgs,
              lib,
              modulesPath,
              ...
            }: {
              imports = [(modulesPath + "/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix")];
            }
          )

          ({
            self,
            system,
            ...
          }: {
            environment.systemPackages = with self.inputs.nix-alien.packages.${system}; [
              nix-alien
            ];
          })
        ];
      };
    };
  };
}
