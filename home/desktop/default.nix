{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./fcitx.nix
    ./services.nix
    ./stylix.nix
    ./vicinae.nix
    ./wallpaperengine.nix

    ./niri

    # ./ashell.nix
    ./noctalia.nix
    # ./caelestia.nix
    # ./dank.nix
    # ./minecraft.nix
  ];
}
