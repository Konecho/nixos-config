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
    /home/commandline
    /home/desktop/fonts.nix
  ];
  home.packages = with pkgs; [
    usbutils # lsusb
  ];
  # prevent build
  programs.helix.languages.language-server.rime-ls.command = lib.mkForce "rime_ls";
}
