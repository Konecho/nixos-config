{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.niri.overlays.default];
  # pacakge is overwrote by system
  # left here for evaluation purposes
  wayland.windowManager.niri.package = pkgs.niri;
  wayland.windowManager.niri.settings.layout.blur = {
    on = [];
    passes = 3;
    radius = 12.0;
    noise = 0.1;
  };
}
