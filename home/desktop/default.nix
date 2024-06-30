{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./fonts.nix
    ./fcitx.nix
    ./theme.nix

    # ./gnome.nix

    ./niri.nix
    ./river.nix

    ./wl-utils.nix
  ];
}
