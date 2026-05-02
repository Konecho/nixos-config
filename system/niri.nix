{
  inputs,
  pkgs,
  ...
}: {
  # will build from source
  # nixpkgs.overlays = [inputs.niri.overlays.default];
  programs.niri.enable = true;
  # programs.niri.package = pkgs.niri;
}
