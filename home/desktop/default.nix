{...}: {
  imports = [
    ./fonts.nix
    ./fcitx.nix
    ./theme.nix

    ./niri.nix

    ./ironbar.nix
  ];
  services.cliphist.enable = true;
}
