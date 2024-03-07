{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.NvChad.homeManagerModules.default
  ];
  # https://github.com/NvChad/nix
  programs.NvChad.enable = true;
}
