{ pkgs, config, ... }:

rec {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./styles/hyprland.conf;
  };
  home.file.waybar-wttr = {
    enable = true;
    executable = true;
    source = ./styles/waybar-wttr.py;
    target = ".config/waybar/scripts/waybar-wttr.py";
  };
  home.file.waybar-config = {
    enable = true;
    executable = false;
    source = ./styles/waybar.jsonc;
    target = ".config/waybar/config";
  };
  home.file.cardboard-config = {
    enable = true;
    executable = true;
    source = ./styles/cardboardrc;
    target = ".config/cardboard/cardboardrc";
  };
}
