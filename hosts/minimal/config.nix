#Grabbed from https://github.com/Misterio77/nix-starter-configs

{
  config,
  pkgs,
  options
  lib,
  inputs,
  stateVersion,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    channel.enable = false;
  };

  networking.hostName = "minimal";

  users.users = {
    ajhyperbit = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };
  system.stateVersion = stateVersion;
}
