{lib, pkgs, config, ...}: {
      lib.mkMerge = {
        boot.binfmt.registrations = {
        WSLInterop = {
          magicOrExtension = "MZ";
          fixBinary = true;
          wrapInterpreterInShell = false;
          interpreter = "/init";
          preserveArgvZero = true;
        };
      };


    environment.sessionVariables = lib.mkForce {}
  };
}