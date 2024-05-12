{
  pkgs,
  lib,
  rootPath,
  ...
}: let
  withModifier = modifier: attrs: (lib.mapAttrs' (name: value: {
      name = modifier + " " + name;
      value = value;
    })
    attrs);
in {
  home.packages = with pkgs; [
    wezterm
    grim
    slurp
    rofi
    playerctl
    pamixer
    light
  ];
  wayland.windowManager.river = {
    enable = true;
    settings = {
      spawn = [
        "clash-verge"
        "mako"
        "'wl-paste --watch cliphist store'"
        "sandbar-status"
        # "sandbar-bar"
        "stylix"
      ];
      map.normal =
        (withModifier "Super" {
          Q = "close";
          Space = "toggle-float";
          F = "toggle-fullscreen";
          T = "spawn river-slurp-term";
          V = "spawn 'wezterm start --class float-clipboard -e cliphist-fzf-sixel &'";
          Print = ''spawn 'grim -g "$(slurp)" - | wl-copy --type image/png' '';
          # Return = "spawn ${pkgs.alacritty}/bin/alacritty";
          Return = "spawn wezterm";
          D = ''spawn "rofi -show run"'';

          # focus the next/previous view in the layout stack
          J = "focus-view next";
          K = "focus-view previous";
          # decrease/increase the main ratio of rivertile(1)
          H = "send-layout-cmd rivertile \"main-ratio -0.05\"";
          L = "send-layout-cmd rivertile \"main-ratio +0.05\"";
          # focus the next/previous output
          Period = "focus-output next";
          Comma = "focus-output previous";
          # change layout orientation
          Up = ''send-layout-cmd rivertile "main-location top"'';
          Right = ''send-layout-cmd rivertile "main-location right"'';
          Down = ''send-layout-cmd rivertile "main-location bottom"'';
          Left = ''send-layout-cmd rivertile "main-location left"'';
        })
        // (withModifier "Super+Shift" {
          E = "exit";
          # bump the focused view to the top of the layout stack
          Return = "zoom";
          # swap the focused view with the next/previous view in the layout stack
          J = "swap next";
          K = "swap previous";
          # increment/decrement the main count of rivertile(1)
          H = "send-layout-cmd rivertile \"main-count +1\"";
          L = "send-layout-cmd rivertile \"main-count -1\"";
          # send the focused view to the next/previous output
          Period = "send-to-output next";
          Comma = "send-to-output previous";
        })
        // (withModifier "Super+Alt" {
          # move views
          H = "move left 100";
          J = "move down 100";
          K = "move up 100";
          L = "move right 100";
        })
        // (withModifier "Super+Alt+Shift" {
          # resize views
          H = "resize horizontal -100";
          J = "resize vertical 100";
          K = "resize vertical -100";
          L = "resize horizontal 100";
        })
        // (withModifier "Super+Alt+Control" {
          # snap views to screen edges
          H = "snap left";
          J = "snap down";
          K = "snap up";
          L = "snap right";
        });
      map-pointer.normal = withModifier "Super" {
        # Mouse Button
        BTN_LEFT = "move-view";
        BTN_RIGHT = "resize-view";
        BTN_MIDDLE = "toggle-float";
      };
      rule-add = {
        "-app-id" = {
          "'bar'" = "csd";
          "'float*'" = "float";
        };
        "-title" = {
          "'窗口投影（预览）'" = "float";
          "Waylyrics" = "float";
        };
      };
    };
    extraConfig = ''
      for i in $(seq 1 9)
      do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $tags

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Shift $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      done

      # Super+0 to focus all tags
      # Super+Shift+0 to tag focused view with all tags
      all_tags=$(((1 << 32) - 1))
      riverctl map normal Super 0 set-focused-tags $all_tags
      riverctl map normal Super+Shift 0 set-view-tags $all_tags

      # Declare a passthrough mode. This mode has only a single mapping to return to
      # normal mode. This makes it useful for testing a nested wayland compositor
      riverctl declare-mode passthrough

      # Super+F11 to enter passthrough mode
      riverctl map normal Super F11 enter-mode passthrough

      # Super+F11 to return to normal mode
      riverctl map passthrough Super F11 enter-mode normal

      # Various media key mapping examples for both normal and locked mode which do not have a modifier
      for mode in normal locked
      do
          # Eject the optical drive (well if you still have one that is)
          riverctl map $mode None XF86Eject spawn 'eject -T'

          # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
          riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
          riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
          riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'

          # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
          riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
          riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

          # Control screen backlight brightness with light (https://github.com/haikarainen/light)
          riverctl map $mode None XF86MonBrightnessUp   spawn 'light -A 5'
          riverctl map $mode None XF86MonBrightnessDown spawn 'light -U 5'
      done

      # Set keyboard repeat rate
      riverctl set-repeat 50 300

      # Set the default layout generator to be rivertile and start it.
      # River will send the process group of the init executable SIGTERM on exit.
      riverctl default-layout rivertile
      rivertile -view-padding 6 -outer-padding 6 &
    '';
    extraSessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
    };
    systemd.variables = ["-all"];
    systemd.extraCommands = [
      "systemctl --user restart river-session.target"
      "systemctl --user restart fcitx5-session.target"
    ];
  };
}
