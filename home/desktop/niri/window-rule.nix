{
  pkgs,
  inputs,
  config,
  ...
}: {
  wayland.windowManager.niri.settings.window-rule = [
    {
      _children = [{match._props.title = "Xwayland";}];
      open-maximized = true;
    }
    {
      _children = [{match._props.app-id = "io.github.waylyrics.Waylyrics";}];
      open-floating = true;
      open-focused = false;
      border.off = [];
      draw-border-with-background = false;
    }
    {
      _children = [
        {match._props.app-id = "wechat";}
        {match._props.title = "图片和视频";}
      ];
      open-floating = true;
    }
    {
      _children = [{match._props.app-id = "ghostty";}];
      draw-border-with-background = false;
    }
    {
      # Rounded corners for a modern look.
      geometry-corner-radius = 20.0;
      # Clips window contents to the rounded corner boundaries.
      clip-to-geometry = true;
    }
  ];
}
