{...}: {
  nix.settings.access-tokens = "${builtins.readFile ./private/nix-access/nix.conf}";
}
