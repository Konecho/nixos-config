{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.niri.overlays.default];
  # pacakge is overwrote by system
  # left here for evaluation purposes
  wayland.windowManager.niri.package = pkgs.niri;
  wayland.windowManager.niri.settings.blur = {
    passes = 3;
    offset = 3;
    noise = 0.02;
    saturation = 1.5;
  };
  wayland.windowManager.niri.settings.window-rule = [
    {
      background-effect = {
        # xray = true;
        blur = true;
      };
    }
    {
      _children = [
        # {match._props.app-id = "ghostty";}
        # {match._props.app-id = "zen-beta";}
      ];
      background-effect.blur = true;
    }
  ];
  wayland.windowManager.niri.settings.layer-rule = [
    {
      _children = [
        {match._props.namespace = "noctalia-bar-content-*";}
        # {match._props.namespace = "noctalia-bar-exclusion-*";}
      ];
      background-effect.blur = true;
    }
  ];
}
