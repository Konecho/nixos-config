{
  pkgs,
  lib,
  config,
  ...
}: let
  TERM = config.home.sessionVariables.TERMINAL;
  withModifierSpawn = modifier: attrs: (lib.mapAttrs' (name: value: {
      name = modifier + "+" + name;
      value.action.spawn = value;
    })
    attrs);
  mkWorkspaceBinds = num:
    if (num == 0)
    then {}
    else
      (
        {
          "Mod+${builtins.toString num}".action.focus-workspace = num;
          "Mod+Shift+${builtins.toString num}".action.move-window-to-workspace = num;
          "Mod+Ctrl+${builtins.toString num}".action.move-column-to-workspace = num;
        }
        // mkWorkspaceBinds (num - 1)
      );
in {
  programs.niri.settings.binds =
    (withModifierSpawn "Mod" {
      "Space" = "hexecute";
      "Return" = TERM;
    })
    // (mkWorkspaceBinds 9)
    // (with config.lib.niri.actions; {
      "Mod+Shift+Slash".action = show-hotkey-overlay;
      "Mod+Q".action = close-window;

      "Mod+Left".action = focus-column-left;
      "Mod+Right".action = focus-column-right;
      "Mod+Down".action = focus-window-down;
      "Mod+Up".action = focus-window-up;
      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+J".action = focus-window-or-workspace-down;
      "Mod+K".action = focus-window-or-workspace-up;

      "Mod+Ctrl+Left".action = move-column-left;
      "Mod+Ctrl+Right".action = move-column-right;
      "Mod+Ctrl+Down".action = move-window-down;
      "Mod+Ctrl+Up".action = move-window-up;
      "Mod+Ctrl+H".action = move-column-left;
      "Mod+Ctrl+L".action = move-column-right;
      "Mod+Ctrl+J".action = move-window-down-or-to-workspace-down;
      "Mod+Ctrl+K".action = move-window-up-or-to-workspace-up;

      "Mod+Home".action = focus-column-first;
      "Mod+End".action = focus-column-last;
      "Mod+Ctrl+Home".action = move-column-to-first;
      "Mod+Ctrl+End".action = move-column-to-last;

      "Mod+Page_Down".action = focus-workspace-down;
      "Mod+Page_Up".action = focus-workspace-up;
      "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
      "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
      "Mod+Shift+Page_Down".action = move-workspace-down;
      "Mod+Shift+Page_Up".action = move-workspace-up;

      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action = focus-column-right;
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action = focus-column-left;
      };
      "Mod+WheelScrollRight".action = focus-column-right;
      "Mod+WheelScrollLeft".action = focus-column-left;
      "Mod+Shift+WheelScrollDown".action = focus-workspace-down;
      "Mod+Shift+WheelScrollUp".action = focus-workspace-up;

      "Mod+Ctrl+WheelScrollDown" = {
        cooldown-ms = 150;
        action = move-column-to-workspace-down;
      };
      "Mod+Ctrl+WheelScrollUp" = {
        cooldown-ms = 150;
        action = move-column-to-workspace-up;
      };
      "Mod+Ctrl+WheelScrollRight".action = move-column-right;
      "Mod+Ctrl+WheelScrollLeft".action = move-column-left;
      "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
      "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

      # "Mod+Tab".action = focus-workspace-previous;
      # "Mod+Comma".action = consume-window-into-column;
      "Mod+Period".action = expel-window-from-column;
      "Mod+BracketLeft".action = consume-or-expel-window-left;
      "Mod+BracketRight".action = consume-or-expel-window-right;

      "Mod+R".action = switch-preset-column-width;
      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;
      "Mod+C".action = center-column;

      # "Mod+Space".action = toggle-overview;
      "Mod+T".action = toggle-window-floating;
      "Mod+Shift+T".action = switch-focus-between-floating-and-tiling;

      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";
      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      "Print".action.screenshot = [];
      # "Ctrl+Print".action = screenshot-screen;
      # "Alt+Print".action = screenshot-window;

      "Mod+Shift+E".action = quit;
      "Mod+Shift+P".action = power-off-monitors;
    });

  xdg.configFile.niri-config.target = lib.mkForce "niri/config.niri-flake.kdl";
  xdg.configFile.niri-config-wrap = {
    enable = true;
    target = "niri/config.kdl";
    text = ''
      include "config.niri-flake.kdl"
      include "noctalia.kdl"
      recent-windows {
          binds {
              Alt+Tab         { next-window; }
              Alt+Shift+Tab   { previous-window; }
              Alt+grave       { next-window     filter="app-id"; }
              Alt+Shift+grave { previous-window filter="app-id"; }

              Mod+Tab         { next-window; }
              Mod+Shift+Tab   { previous-window; }
              Mod+grave       { next-window     filter="app-id"; }
              Mod+Shift+grave { previous-window filter="app-id"; }
          }
      }
    '';
  };
}
