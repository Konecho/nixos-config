{
  inputs,
  pkgs,
  ...
}: {
  #  with cachix
  imports = [inputs.niri.nixosModules.niri];
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  programs.niri.enable = true;
  # will build from source
  # programs.niri.package = pkgs.niri-unstable;
}
