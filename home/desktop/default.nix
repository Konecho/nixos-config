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
    ./theme.nix

    ./hyprland.nix
    ./dwl
    ./qtile
    ./river
  ];
  i18n.inputMethod = {
    enabled = "fcitx5";
    # fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    # fcitx5.enableRimeData = true;
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      # fcitx5-rime
      # rime-data
    ];
  };
  systemd.user.services.fcitx5-daemon.Service.ExecStart = lib.mkForce "${config.i18n.inputMethod.package}/bin/fcitx5 --keep";
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
