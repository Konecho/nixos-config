{...}: {
  imports = [
    ./cli-rust.nix
    ./cli.nix
    ./starship.nix
    ./fish.nix
    ./gpg.nix
    ./helix.nix
    ./uiua.nix
    # ./lowfreq.nix
    ./nushell.nix
    ./pkm-shell.nix
    ./scripts.nix
    ./yazi.nix
  ];
}
