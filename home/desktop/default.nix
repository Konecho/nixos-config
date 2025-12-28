{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./fcitx.nix
    ./services.nix
    ./stylix.nix
    ./vicinae.nix
    ./wallpaperengine.nix

    ./snipaste.nix

    ./niri.nix

    # ./ashell.nix
    ./noctalia.nix
    # ./caelestia.nix
    # ./dank.nix
    # ./minecraft.nix
  ];
}
