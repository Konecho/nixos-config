{ pkgs, config, ... }:

rec {
  wayland.windowManager.hyprland = { enable = true; extraConfig = builtins.readFile ./styles/hyprland.conf; };
}
