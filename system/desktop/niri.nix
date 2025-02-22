{
  inputs,
  pkgs,
  ...
}: {
  #  with cachix
  imports = [inputs.niri.nixosModules.niri];
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    default_input = "password";
    # numlock = true;
    # xinitrc = "niri";
    # animation = "doom";
    animation = "matrix";
    # bigclock = "en"; # don not enable with animation
  };
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  programs.niri.enable = true;
  # will build from source
  programs.niri.package = pkgs.niri-unstable;
}
