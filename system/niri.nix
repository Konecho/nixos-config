{
  inputs,
  pkgs,
  ...
}: {
  #  with cachix
  imports = [inputs.niri-flake.nixosModules.niri];
  # will build from source
  # nixpkgs.overlays = [inputs.niri.overlays.default];
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
}
