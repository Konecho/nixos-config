{
  pkgs,
  rootPath,
  lib,
  ...
}: {
  imports = map (path: rootPath + path) [
    /home/common.nix
    /home/nix.nix
    /home/editors/helix.nix
    # /home/editors/nvchad.nix

    /home/commandline/default.nix

    /home/desktop/fonts.nix
  ];
  home.packages = with pkgs; [
    usbutils # lsusb
  ];
  programs.helix.settings.theme = "base16";
  programs.helix.themes.base16 = {
    inherits = "github_light";
    "ui.background" = {};
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 16;
  };
}
