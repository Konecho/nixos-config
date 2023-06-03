{
  pkgs,
  config,
  ...
}: let
  screenWidth = 1440;
  screenHeight = 900;
  # fontsize=12 cellsize=10x21
  cellWidth = 10;
  cellHeight = 21;
  gaps = 2;
  border = 3; # 2*(gaps+border)==cellWidth
  # ~/.config/stylix/palette.html
  base16 = config.lib.stylix.colors;
  baseConfigs = ''
    monitor=,preferred,auto,1
    monitor=,addreserved,${builtins.toString (screenHeight - ((screenHeight - (gaps + border)) / cellHeight - 1) * cellHeight - 2 * (gaps + border))},0,0,0

    input {
      kb_options = caps:escape
      follow_mouse = 2
      float_switch_override_focus = 2
      numlock_by_default = true
      # touchpad.natural_scroll = yes
    }
    general {
      # gaps between windows
      gaps_in = ${builtins.toString gaps}
      gaps_out = ${builtins.toString gaps}
      border_size = ${builtins.toString border}
      # 1440x900->1430x890
      col.active_border = rgb(${base16.base07})
      col.inactive_border = rgba(${base16.base0F}aa)
      layout = dwindle # master|dwindle
    }
    dwindle {
      no_gaps_when_only = false
      force_split = 0
      special_scale_factor = 0.8
      split_width_multiplier = 1.0
      use_active_for_splits = true
      pseudotile = yes
      preserve_split = yes
    }
    master {
      new_is_master = true
      special_scale_factor = 0.8
      no_gaps_when_only = false
    }
    # cursor_inactive_timeout = 0
    decoration {
      multisample_edges = true
      active_opacity = 1.0
      inactive_opacity = 1.0
      fullscreen_opacity = 1.0
      rounding = 0
      blur = no
      blur_size = 3
      blur_passes = 1
      blur_new_optimizations = true
      drop_shadow = false
      shadow_range = 4
      shadow_render_power = 3
      shadow_ignore_window = true
      # col.shadow =
      # col.shadow_inactive
      # shadow_offset
      dim_inactive = false
      # dim_strength = #0.0 ~ 1.0
      blur_ignore_opacity = false
      col.shadow = rgba(003472ee)
    }
    animations {
      enabled = 1
      bezier = overshot, 0.13, 0.99, 0.29, 1.1
      animation = windows, 1, 4, overshot, slide
      animation = windowsOut, 1, 5, default, popin 80%
      animation = border, 1, 5, default
      animation = fade, 1, 8, default
      animation = workspaces, 1, 6, overshot, slidevert
    }
    gestures {
      workspace_swipe = true
      workspace_swipe_fingers = 4
      workspace_swipe_distance = 250
      workspace_swipe_invert = true
      workspace_swipe_min_speed_to_force = 15
      workspace_swipe_cancel_ratio = 0.5
      workspace_swipe_create_new = false
    }
    misc {
      disable_autoreload = true
      disable_hyprland_logo = true
      always_follow_on_dnd = true
      layers_hog_keyboard_focus = true
      animate_manual_resizes = false
      enable_swallow = true
      swallow_regex =
      focus_on_activate = true
    }
  '';
  keyBinds = ''
    $mod = SUPER
    ## run <nix run n#wev> to test keycode

    # bind = SUPER, Return, exec, alacritty
    # bind = SUPER SHIFT, Return, exec, alacritty --class="termfloat"

    bind = SUPER, Return, exec, wezterm start
    bind = SUPER SHIFT, Return, exec, wezterm start --class termfloat

    bind = SUPER, D, exec, kickoff
    bind = SUPER SHIFT, Q, killactive,
    bind = SUPER SHIFT, E, exit,
    bind = SUPER SHIFT, Space, togglefloating,
    bind = SUPER SHIFT, F ,fullscreen,

    bind = SUPER, P, pseudo, # dwindle
    bind = SUPER, V, togglesplit, # dwindle

    bind = SUPER, K, togglegroup,
    bind = SUPER, Tab, changegroupactive, f

    bind = SUPER, left, movefocus, l
    bind = SUPER, right, movefocus, r
    bind = SUPER, up, movefocus, u
    bind = SUPER, down, movefocus, d

    # workspaces
    # binds mod + [shift +] {1..10} to [move to] ws {1..10}
    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $mod, ${ws}, workspace, ${toString (x + 1)}
          bind = $mod CTRL, ${ws}, movetoworkspace, ${toString (x + 1)}
          bind = $mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}
        ''
      )
      10)}
    bind = SUPER, L, workspace, +1
    bind = SUPER, H, workspace, -1
    bind = SUPER, period, workspace, e+1
    bind = SUPER, comma, workspace, e-1
    bind = SUPER CTRL, left, movetoworkspace, -1
    bind = SUPER CTRL, right, movetoworkspace, +1
    bind = SUPER, mouse_down, workspace, e+1
    bind = SUPER, mouse_up, workspace, e-1
    #-------------------------------#
    # special workspace(scratchpad) #
    #-------------------------------#
    bind = SUPER, minus, movetoworkspace,special
    bind = SUPER, equal, togglespecialworkspace
    bind = SUPER, code:49, togglespecialworkspace
    #----------------------------------#
    # move window in current workspace #
    #----------------------------------#
    bind = SUPER SHIFT,left ,movewindow, l
    bind = SUPER SHIFT,right ,movewindow, r
    bind = SUPER SHIFT,up ,movewindow, u
    bind = SUPER SHIFT,down ,movewindow, d
    #-----------------------------------------#
    # control volume,brightness,media players #
    #-----------------------------------------#
    bind=,XF86AudioRaiseVolume,exec, pamixer -i 5
    bind=,XF86AudioLowerVolume,exec, pamixer -d 5
    bind=,XF86AudioMute,exec, pamixer -t
    bind=,XF86AudioMicMute,exec, pamixer --default-source -t
    bind=,XF86MonBrightnessUp,exec, light -A 5
    bind=,XF86MonBrightnessDown, exec, light -U 5
    bind=,XF86AudioPlay,exec, playerctl play-pause
    bind=,XF86AudioNext,exec, playerctl next
    bind=,XF86AudioPrev,exec, playerctl previous
    #---------------#
    # resize window #
    #---------------#
    bind=SUPER,R,submap,resize
    submap=resize
    binde=,right,resizeactive,15 0
    binde=,left,resizeactive,-15 0
    binde=,up,resizeactive,0 -15
    binde=,down,resizeactive,0 15
    binde=,l,resizeactive,15 0
    binde=,h,resizeactive,-15 0
    binde=,k,resizeactive,0 -15
    binde=,j,resizeactive,0 15
    bind=,escape,submap,reset
    submap=reset
    bind=CTRL SHIFT, left, resizeactive,-15 0
    bind=CTRL SHIFT, right, resizeactive,15 0
    bind=CTRL SHIFT, up, resizeactive,0 -15
    bind=CTRL SHIFT, down, resizeactive,0 15
    bind=CTRL SHIFT, l, resizeactive, 15 0
    bind=CTRL SHIFT, h, resizeactive,-15 0
    bind=CTRL SHIFT, k, resizeactive, 0 -15
    bind=CTRL SHIFT, j, resizeactive, 0 15
    bindm = SUPER, mouse:272, movewindow
    bindm = SUPER, mouse:273, resizewindow
    # bind = SUPER SHIFT, G,exec,hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"
    # bind = SUPER , G,exec,hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"
  '';
  autoStart = ''
    # exec-once = waybar &
    # exec-once=eww daemon &
    # exec-once=eww open bar &
    exec-once = fcitx5 -d &
    exec-once = mako &
    exec-once = clash-verge &
    exec-once = swww init &
    exec-once = pokemon -w 615&
    # exec-once = alacritty --class="termbar" --command="shox" -o "colors.cursor.cursor=CellBackground" -o "colors.cursor.text=CellForeground"
    exec-once = alacritty --class="termbar" -o "colors.cursor.cursor='0xffffff'" -e bash -c 'tput civis && baru | tr "\n" "\r"'
    # exec-once = alacritty --class="scratchpad" &
  '';
  winRules = ''
    #`hyprctl clients` get class、title...
    # https://wiki.hyprland.org/Configuring/Window-Rules/ for more

    windowrule=float,title:^(窗口投影（预览）)$
    windowrule=size 1280 720,title:^(窗口投影（预览）)$
    windowrule=center,title:^(窗口投影（预览）)$

    windowrule=size 1200 630,termfloat # fontsize=12 cellsize=10x21
    windowrule=center,termfloat

    windowrule=size ${builtins.toString (screenWidth - 2 * (border + gaps))} ${builtins.toString cellHeight},termbar
    windowrule=move ${builtins.toString (border + gaps)} ${builtins.toString (border + gaps)},termbar

    windowrule=opacity 0.95,title:Telegram
    windowrule=opacity 0.95,title:QQ

    windowrule=workspace 10 silent,title:^(Clash Verge)$
    windowrule=float,title:^(Clash Verge)$
    # windowrule=workspace special silent,class:scratchpad

    windowrule=float,imv
    windowrule=float,mpv
    windowrule=float,ncmpcpp
    windowrule=float,termbar

    windowrule=float,termfloat
    windowrule=pin,termbar

    windowrule=animation slide right,termfloat
    windowrule=opacity 0.95 0.8,termfloat
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      ${baseConfigs}
      ${keyBinds}
      ${autoStart}
      ${winRules}
    '';
  };
}
