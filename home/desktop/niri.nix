{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  TERM = config.home.sessionVariables.TERMINAL;
in {
  imports = [
    inputs.niri.homeModules.config
    inputs.niri.homeModules.stylix
  ];
  # programs.niri.settings.xwayland-satellite = {
  #   enable = true;
  #   # path = pkgs.xwayland-satellite-unstable;
  # };
  programs.niriswitcher = {
    enable = true;
    settings = {
      keys = {
        modifier = "Mod";
        switch = {
          next = "Tab";
          prev = "Shift+Tab";
        };
      };
      center_on_focus = true;
      appearance = {
        system_theme = "dark";
        icon_size = 64;
      };
    };
  };
  programs.niri.settings.spawn-at-startup = [
    {command = ["niriswitcher"];}
  ];
  programs.niri.settings = {
    environment = {
      NIXOS_OZONE_WL = "1";
      GDK_BACKEND = "wayland"; # gtk wayland
      QT_QPA_PLATFORM = "wayland"; # qt wayland
      MOZ_ENABLE_WAYLAND = "1"; # firefox / icecat
      DISPLAY = ":0"; # xwayland-satellite
    };
    prefer-no-csd = true;
    screenshot-path = "~/media/photos/screenshots/niri %Y-%m-%d %H-%M-%S.png";
    window-rules = [
      {
        geometry-corner-radius = {
          bottom-left = 12.0;
          bottom-right = 12.0;
          top-left = 12.0;
          top-right = 12.0;
        };
        clip-to-geometry = true;
      }
      {
        matches = [{title = "Xwayland";}];
        open-maximized = true;
      }
    ];
    input = {
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "20%";
      };
    };
    outputs."HDMI-A-1" = {
      mode = {
        height = 1080;
        width = 1920;
      };
      # scale = 1.25;
    };
    binds = let
      withModifierSpawn = modifier: attrs: (lib.mapAttrs' (name: value: {
          name = modifier + "+" + name;
          value = {
            action.spawn = value;
          };
        })
        attrs);
    in
      (withModifierSpawn "Mod" {
        "D" = "fuzzel";
        "T" = TERM;
        "Return" = TERM;
        "Tab" = ["niriswitcherctl" "show" "--window"];
        "Shift+Tab" = ["niriswitcherctl" "show" "--window"];
        "Grave" = ["niriswitcherctl" "show" "--workspace"];
        "Shift+Grave" = ["niriswitcherctl" "show" "--workspace"];
      })
      // (
        let
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
        in (mkWorkspaceBinds 9)
      )
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
          action = focus-workspace-down;
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action = focus-workspace-up;
        };
        "Mod+WheelScrollRight".action = focus-column-right;
        "Mod+WheelScrollLeft".action = focus-column-left;

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

        "Mod+Shift+WheelScrollDown".action = focus-column-right;
        "Mod+Shift+WheelScrollUp".action = focus-column-left;

        "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
        "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

        #     "Mod+Tab".action = focus-workspace-previous;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        "Mod+R".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Print".action = screenshot;
        # "Ctrl+Print".action = screenshot-screen;
        # "Alt+Print".action = screenshot-window;

        "Mod+Shift+E".action = quit;
        "Mod+Shift+P".action = power-off-monitors;
      });
  };
}
