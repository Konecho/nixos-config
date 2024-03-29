{
  pkgs,
  rootPath,
  ...
}: {
  imports = map (path: rootPath + path) [
    /home/common.nix
    /home/nix.nix
    /home/editors/helix.nix
    /home/editors/nvchad.nix
    /home/commandline
    /home/desktop/fonts.nix
  ];
  home.packages = with pkgs; [
    julia
    usbutils # lsusb
  ];
}
