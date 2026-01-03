{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  home.packages = [
    inputs.niri-nix.packages.${pkgs.stdenv.hostPlatform.system}.xwayland-satellite-unstable
  ];
  wayland.windowManager.niri.settings.spawn-at-startup = [
    ["clash-verge"]
    ["fcitx5" "-r" "-d"]
    ["xwayland-satellite"]
  ];
}
