{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    # ./bars.nix
    # ./eww
    ./fonts.nix
    ./fcitx.nix
    ./theme.nix

    ./hyprland.nix
    # ./dwl
    # ./qtile
    # ./river
  ];
  services.mako = {
    enable = true;
    # font = "monospace 12";
  };
  services.clipman.enable = true;
  # programs.eww = {
  #   enable = true;
  #   package = pkgs.eww-wayland;
  #   configDir = ./eww;
  # };
  home.packages = with pkgs; [
    ## [[app runner]]
    # kickoff
    wofi
    #   lua
    #   pamixer
    #   brightnessctl
    #   (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];
}
