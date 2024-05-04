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
    ./mako.nix

    # ./gnome.nix

    # ./hyprland.nix

    ./niri.nix
    ./river.nix

    ./wl-utils.nix
  ];
}
