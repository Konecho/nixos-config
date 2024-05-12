{...}: {
  imports = [
    ./cli.nix
    ./riir.nix
    # ./lowfreq.nix
    ./fish.nix
    ./nushell.nix
    ./pkm-shell.nix
    ./git.nix
    ./gpg.nix
    ./scripts.nix
  ];
}
