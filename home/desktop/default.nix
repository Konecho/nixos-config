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
    # ./ags.nix

    # ./hyprland.nix
    # ./dwl
    # ./qtile
    ./niri.nix
    ./river

    # ./bars.nix
    # ./eww
    ./wl-utils.nix
  ];
  # services.mako = {
  #   enable = true;
  #   # font = "monospace 12";
  # };
  # services.clipman.enable = true;
  # programs.eww = {
  #   enable = true;
  #   package = pkgs.eww-wayland;
  #   configDir = ./eww;
  # };
  # home.packages = with pkgs; [
  #   ## [[app runner]]
  #   # kickoff
  #   wofi
  #   #   lua
  #   #   pamixer
  #   #   brightnessctl
  #   #   (nerdfonts.override {fonts = ["JetBrainsMono"];})
  # ];
}
