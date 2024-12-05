{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  system,
  ...
}: {
  environment.systemPackages = with pkgs; [
    #x11
    #xrdp
    #xorg.xinit
    #x11vnc
    #virtualglLib
  ];
}
