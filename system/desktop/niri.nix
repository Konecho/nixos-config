{
  inputs,
  pkgs,
  ...
}: {
  #  add the niri.nixosModules.niri module and don't enable niri yet. Rebuild your system once to enable the binary cache, then enable niri.
  imports = [inputs.niri.nixosModules.niri];
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  programs.niri.enable = true;
}
