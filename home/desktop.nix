{ pkgs, config, ... }:

rec {
  imports = [ ./hyprland.nix ];
  gtk = {
    enable = true;
    cursorTheme = { name = "Vanilla-DMZ"; package = pkgs.vanilla-dmz; };
    theme = {
      name = "Pop";
      package = pkgs.pop-gtk-theme;
    };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-solarized-gtk-theme;
    };
  };
  systemd.user.sessionVariables.PATH = "${pkgs.systemd}:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin/";

  programs.kitty = {
    enable = true;
    font = {
      size = 12;
      name = "Maple Mono SC NF";
    };
    settings = { background_opacity = "0.8"; window_border_width = "2px"; window_margin_width = 1; };
  };
  programs.alacritty = {
    enable = true;
    settings = {
      opacity = 0.8;
      font.normal.family = "Maple Mono SC NF";
      font.size = 12;
    };
  };
}