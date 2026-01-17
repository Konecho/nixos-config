{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./fcitx.nix
    ./services.nix
    ./stylix.nix
    ./vicinae.nix
    ./wallpaperengine.nix

    ./niri
    ./shells
  ];
}
