{...}: {
  imports = [
    ./fonts.nix
    ./fcitx.nix
    ./services.nix

    ./niri.nix

    ./ironbar.nix
  ];
  services.cliphist.enable = true;
}
