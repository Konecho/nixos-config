{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./fcitx.nix
    ./services.nix
    ./stylix.nix

    ./niri.nix
    ./niriswitcher.nix

    ./noctalia.nix
    # ./caelestia.nix
    # ./dank.nix
    # ./minecraft.nix
  ];
  # services.poweralertd.enable = true;
}
