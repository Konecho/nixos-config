{...}: {
  imports = [
    ./cli-rust.nix
    ./cli.nix
    ./starship.nix
    ./fish.nix
    ./gpg.nix
    ./helix.nix
    ./fresh-editor.nix
    ./uiua.nix
    ./nushell.nix
    # ./pkm-shell.nix
    ./scripts.nix
    ./yazi.nix
    ./pi.nix
  ];
}
