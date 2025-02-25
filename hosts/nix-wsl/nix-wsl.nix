{lib, pkgs, ...}: {
      lib.mkMerge = {
        boot.binfmt.registrations = mkIf cfg.register {
        WSLInterop = {
          magicOrExtension = "MZ";
          fixBinary = true;
          wrapInterpreterInShell = false;
          interpreter = "/init";
          preserveArgvZero = true;
        };
      };
    };
}