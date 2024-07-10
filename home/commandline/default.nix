{...}: {
  imports = [
    ./cli.nix
    ./rust-utils.nix
    # ./lowfreq.nix
    ./fish.nix
    ./nushell.nix
    ./pkm-shell.nix
    ./git.nix
    ./gpg.nix
    ./scripts.nix
  ];
}
