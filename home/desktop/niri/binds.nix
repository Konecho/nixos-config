{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  TERM = config.home.sessionVariables.TERMINAL;
  mkWorkspaceBinds = num:
    if (num == 0)
    then {}
    else
      (
        {
          "Mod+${builtins.toString num}".focus-workspace = num;
          "Mod+Shift+${builtins.toString num}".move-window-to-workspace = num;
          "Mod+Ctrl+${builtins.toString num}".move-column-to-workspace = num;
        }
        // mkWorkspaceBinds (num - 1)
      );
in {
  home.packages = with pkgs; [
    inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  wayland.windowManager.niri.settings.binds =
    (mkWorkspaceBinds 9)
    // {
      "Mod+Space".spawn = ["hexecute"];
      "Mod+Return".spawn = [TERM];

      "Mod+Shift+Slash".show-hotkey-overlay = [];
      "Mod+Q".close-window = [];

      "Mod+Left".focus-column-left = [];
      "Mod+Right".focus-column-right = [];
      "Mod+Down".focus-window-down = [];
      "Mod+Up".focus-window-up = [];
      "Mod+H".focus-column-left = [];
      "Mod+L".focus-column-right = [];
      "Mod+J".focus-window-or-workspace-down = [];
      "Mod+K".focus-window-or-workspace-up = [];

      "Mod+Ctrl+Left".move-column-left = [];
      "Mod+Ctrl+Right".move-column-right = [];
      "Mod+Ctrl+Down".move-window-down = [];
      "Mod+Ctrl+Up".move-window-up = [];
      "Mod+Ctrl+H".move-column-left = [];
      "Mod+Ctrl+L".move-column-right = [];
      "Mod+Ctrl+J".move-window-down-or-to-workspace-down = [];
      "Mod+Ctrl+K".move-window-up-or-to-workspace-up = [];

      "Mod+Home".focus-column-first = [];
      "Mod+End".focus-column-last = [];
      "Mod+Ctrl+Home".move-column-to-first = [];
      "Mod+Ctrl+End".move-column-to-last = [];

      "Mod+Page_Down".focus-workspace-down = [];
      "Mod+Page_Up".focus-workspace-up = [];
      "Mod+Ctrl+Page_Down".move-column-to-workspace-down = [];
      "Mod+Ctrl+Page_Up".move-column-to-workspace-up = [];
      "Mod+Shift+Page_Down".move-workspace-down = [];
      "Mod+Shift+Page_Up".move-workspace-up = [];

      "Mod+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        focus-column-right = [];
      };
      "Mod+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        focus-column-left = [];
      };
      "Mod+WheelScrollRight".focus-column-right = [];
      "Mod+WheelScrollLeft".focus-column-left = [];
      "Mod+Shift+WheelScrollDown".focus-workspace-down = [];
      "Mod+Shift+WheelScrollUp".focus-workspace-up = [];

      "Mod+Ctrl+WheelScrollDown" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-down = [];
      };
      "Mod+Ctrl+WheelScrollUp" = {
        _props.cooldown-ms = 150;
        move-column-to-workspace-up = [];
      };
      "Mod+Ctrl+WheelScrollRight".move-column-right = [];
      "Mod+Ctrl+WheelScrollLeft".move-column-left = [];
      "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = [];
      "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = [];

      # "Mod+Tab".focus-workspace-previous = [];
      # "Mod+Comma".consume-window-into-column = [];
      "Mod+Period".expel-window-from-column = [];
      "Mod+BracketLeft".consume-or-expel-window-left = [];
      "Mod+BracketRight".consume-or-expel-window-right = [];
      "Mod+W".toggle-column-tabbed-display = [];

      "Mod+R".switch-preset-column-width = [];
      "Mod+F".maximize-column = [];
      "Mod+Shift+F".fullscreen-window = [];
      "Mod+C".center-column = [];

      # "Mod+Space".toggle-overview = [];
      "Mod+T".toggle-window-floating = [];
      "Mod+Shift+T".switch-focus-between-floating-and-tiling = [];

      "Mod+Minus".set-column-width = "-10%";
      "Mod+Equal".set-column-width = "+10%";
      "Mod+Shift+Minus".set-window-height = "-10%";
      "Mod+Shift+Equal".set-window-height = "+10%";

      "Print".screenshot = [];
      # "Ctrl+Print".screenshot-screen = [];
      # "Alt+Print".screenshot-window = [];

      "Mod+Shift+E".quit = [];
      "Mod+Shift+P".power-off-monitors = [];
    };
}
