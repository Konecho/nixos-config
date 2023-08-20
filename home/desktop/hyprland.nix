{
  pkgs,
  config,
  lib,
  ...
}: let
  hyprKickoffTab = pkgs.writeScript "kickoff-tab.sh" ''
    #!/usr/bin/env fish
    hyprctl clients -j | jq -r '.[] | select(.title != "") | "[\\(.workspace.id % 10)] \\(.title)=hyprctl dispatch workspace \\(.workspace.id)\\n"' | kickoff --from-stdin
  '';
  screenWidth = 1920;
  screenHeight = 1080;
  # fontsize=12 cellsize=10x21
  cellWidth = 10;
  cellHeight = 21;
  gaps = 2;
  border = 2; # 2*(gaps+border)==cellWidth
  # gaps = 0;
  # border = 0; # 2*(gaps+border)==cellWidth

  # ~/.config/stylix/palette.html
  # base16 = config.lib.stylix.colors;

  # reservedBarHeight = 21;
  reservedBarHeight = 0;
  reservedHeight = reservedBarHeight + 2 * (gaps + border);
  reservedTB = screenHeight - ((screenHeight - reservedHeight) / cellHeight) * cellHeight - reservedHeight;

  baseConfigs = ''
    monitor=,preferred,auto,1
    ##### for top bar
    # monitor=,addreserved,${builtins.toString (reservedTB + reservedBarHeight)},0,0,0
    ##### for bottom bar
    # monitor=,addreserved,0,${builtins.toString (reservedTB + reservedBarHeight)},0,0
    ##### for no bar
    monitor=,addreserved,${builtins.toString (reservedTB / 2)},${builtins.toString (reservedTB - reservedTB / 2)},0,0

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
      layout = dwindle # master|dwindle
      # col.active_border = rgb(ff0000) rgb(ff7f00) rgb(ffff00) rgb(00ff00) rgb(00ffff) rgb(0000ff) rgb(8b00ff) 30deg
      col.active_border = rgb(ff0000) rgb(000000) rgb(8b00ff) 60deg
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

    # █▀▄ █▀▀ █▀▀ █▀█ █▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
    # █▄▀ ██▄ █▄▄ █▄█ █▀▄ █▀█ ░█░ █ █▄█ █░▀█

    decoration {

      # █▀█ █▀█ █░█ █▄░█ █▀▄   █▀▀ █▀█ █▀█ █▄░█ █▀▀ █▀█
      # █▀▄ █▄█ █▄█ █░▀█ █▄▀   █▄▄ █▄█ █▀▄ █░▀█ ██▄ █▀▄
      rounding = 0
      # multisample_edges = true

      # █▀█ █▀█ ▄▀█ █▀▀ █ ▀█▀ █▄█
      # █▄█ █▀▀ █▀█ █▄▄ █ ░█░ ░█░
      active_opacity = 1.0
      inactive_opacity = 1.0

      # █▄▄ █░░ █░█ █▀█
      # █▄█ █▄▄ █▄█ █▀▄
      blur = true
      blur_size = 6
      blur_passes = 3
      blur_new_optimizations = true
      blur_xray = true
      blur_ignore_opacity = true

      # █▀ █░█ ▄▀█ █▀▄ █▀█ █░█░█
      # ▄█ █▀█ █▀█ █▄▀ █▄█ ▀▄▀▄▀
      drop_shadow = false
      shadow_ignore_window = true
      shadow_offset = 1 2
      shadow_range = 10
      shadow_render_power = 5
      col.shadow = 0x66404040

      # blurls = gtk-layer-shell
      # blurls = waybar
      blurls = lockscreen
    }

    animations {
      enabled = 1
      bezier = overshot, 0.13, 0.99, 0.29, 1.1
      bezier = linear,0.5,0.5,0.5,0.5
      animation = windows, 1, 4, overshot, slide
      animation = windowsOut, 1, 5, default, popin 80%
      animation = border, 1, 5, default
      animation = borderangle, 1, 20, linear, loop
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
      groupbar_titles_font_size = 12
      groupbar_gradients = false
    }
  '';
  keyBinds = ''
    $MOD = SUPER
    ## run <nix run n#wev> to test keycode

    # bind = $MOD, Return, exec, ${pkgs.wezterm}/bin/wezterm start
    bind = $MOD, Return, exec, ${pkgs.alacritty}/bin/alacritty --class='term_main'
    # bind = $MOD SHIFT, Return, exec, ${pkgs.wezterm}/bin/wezterm start --class term_float
    bind = $MOD SHIFT, Return, exec, ${pkgs.alacritty}/bin/alacritty --class='term_float'

    bind = $MOD, D, exec, ${pkgs.kickoff}/bin/kickoff
    bind = $MOD SHIFT, Q, killactive,
    bind = $MOD SHIFT, E, exit,
    bind = $MOD SHIFT, Space, togglefloating,
    bind = $MOD SHIFT, F ,fullscreen,

    bind = $MOD, P, pseudo, # dwindle
    bind = $MOD, V, togglesplit, # dwindle

    bind = $MOD, K, togglegroup,
    bind = $MOD SHIFT, Tab, changegroupactive, f
    bind = $MOD, Tab, exec, ${hyprKickoffTab}

    bind = $MOD, left, movefocus, l
    bind = $MOD, right, movefocus, r
    bind = $MOD, up, movefocus, u
    bind = $MOD, down, movefocus, d

    # workspaces
    # binds mod + [shift +] {1..10} to [move to] ws {1..10}
    ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in ''
          bind = $MOD, ${ws}, workspace, ${toString (x + 1)}
          bind = $MOD CTRL, ${ws}, movetoworkspace, ${toString (x + 1)}
          bind = $MOD SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}
        ''
      )
      10)}
    bind = $MOD, L, workspace, +1
    bind = $MOD, H, workspace, -1
    bind = $MOD, period, workspace, e+1
    bind = $MOD, comma, workspace, e-1
    bind = $MOD CTRL, left, movetoworkspace, -1
    bind = $MOD CTRL, right, movetoworkspace, +1
    bind = $MOD, mouse_down, workspace, e+1
    bind = $MOD, mouse_up, workspace, e-1
    #-------------------------------#
    # special workspace(scratchpad) #
    #-------------------------------#
    bind = $MOD, minus, movetoworkspace,special
    bind = $MOD, equal, togglespecialworkspace
    bind = $MOD, code:49, togglespecialworkspace
    #----------------------------------#
    # move window in current workspace #
    #----------------------------------#
    bind = $MOD SHIFT,left ,movewindow, l
    bind = $MOD SHIFT,right ,movewindow, r
    bind = $MOD SHIFT,up ,movewindow, u
    bind = $MOD SHIFT,down ,movewindow, d
    #-----------------------------------------#
    # control volume,brightness,media players #
    #-----------------------------------------#
    bind=,XF86AudioRaiseVolume,exec, ${pkgs.pamixer}/bin/pamixer -i 5
    bind=,XF86AudioLowerVolume,exec, ${pkgs.pamixer}/bin/pamixer -d 5
    bind=,XF86AudioMute,exec, ${pkgs.pamixer}/bin/pamixer -t
    bind=,XF86AudioMicMute,exec, ${pkgs.pamixer}/bin/pamixer --default-source -t
    bind=,XF86MonBrightnessUp,exec, ${pkgs.light}/bin/light -A 5
    bind=,XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 5
    bind=,XF86AudioPlay,exec, ${pkgs.playerctl}/bin/playerctl play-pause
    bind=,XF86AudioNext,exec, ${pkgs.playerctl}/bin/playerctl next
    bind=,XF86AudioPrev,exec, ${pkgs.playerctl}/bin/playerctl previous
    #---------------#
    # resize window #
    #---------------#
    bind=$MOD,r,submap,resize
    submap=resize
    binde=,right,resizeactive,${builtins.toString cellWidth} 0
    binde=,left,resizeactive,-${builtins.toString cellWidth} 0
    binde=,up,resizeactive,0 -${builtins.toString cellHeight}
    binde=,down,resizeactive,0 ${builtins.toString cellHeight}
    binde=,l,resizeactive,${builtins.toString cellWidth} 0
    binde=,h,resizeactive,-${builtins.toString cellWidth} 0
    binde=,k,resizeactive,0 -${builtins.toString cellHeight}
    binde=,j,resizeactive,0 ${builtins.toString cellHeight}
    bind=,escape,submap,reset
    submap=reset
    bindm = $MOD, mouse:272, movewindow
    bindm = $MOD, mouse:273, resizewindow
    # bind = $MOD SHIFT, G,exec,hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"
    # bind = $MOD , G,exec,hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"
  '';
  autoStart = ''
    exec-once = ${pkgs.clash-verge}/bin/clash-verge &
    exec-once = ${pkgs.swww}/bin/swww init &

    # exec = ${pkgs.mypkgs.pokemon-terminal}/bin/pokemon -w 615 &

    # exec-once = ${pkgs.xmobar}/bin/xmobar -b &
    # exec-once=eww daemon &
    # exec-once=eww open bar &

    ##### or use terminal as bar
    ${builtins.concatStringsSep " " [
      # "exec-once = ${pkgs.alacritty}/bin/alacritty --class='termbar' "
      # "-e ${pkgs.bash}/bin/bash"
      # "-c 'tput civis &&"
      # "${pkgs.xmobar}/bin/xmobar -T |"
      # # "${pkgs.mypkgs.baru}/bin/baru |"
      # "cut -c 1-${builtins.toString ((screenWidth / cellWidth) - 1)} |"
      # "tr \"\\n\" \"\\r\"'"
    ]}

    # exec-once = ${pkgs.wezterm}/bin/wezterm start --class term_main
    exec-once = ${pkgs.alacritty}/bin/alacritty --class='term_main'
  '';
  winRules = ''
    #`hyprctl clients` get class、title...
    # https://wiki.hyprland.org/Configuring/Window-Rules/ for more

    ## obs
    windowrule=float,title:^(窗口投影（预览）)$
    windowrule=size 1280 720,title:^(窗口投影（预览）)$
    windowrule=center,title:^(窗口投影（预览）)$

    windowrule=size 1200 630,term_float # fontsize=12 cellsize=10x21
    windowrule=center,term_float
    windowrule=float,term_float
    windowrulev2=opacity 0.80 0.80,class:term_float
    windowrule=animation slide right,term_float
    windowrule=opacity 0.95 0.8,term_float

    windowrule=size ${builtins.toString (screenWidth - 2 * (border + gaps))} ${builtins.toString cellHeight},termbar
    windowrule=move ${builtins.toString (border + gaps)} ${builtins.toString (border + gaps)},termbar

    windowrule=opacity 0.95,title:Telegram
    windowrule=opacity 0.95,title:QQ

    windowrule=workspace 1,term_main
    windowrulev2=opacity 0.80 0.80,class:term_main

    windowrule=workspace 10 silent,title:^(Clash Verge)$
    windowrule=float,title:^(Clash Verge)$
    # windowrule=workspace special silent,class:scratchpad

    windowrule=float,imv
    windowrule=float,mpv
    windowrule=float,ncmpcpp

    windowrule=float,termbar
    windowrule=pin,termbar
    windowrule=pin,xmobar
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    systemdIntegration = true;
    extraConfig = ''
      ${baseConfigs}
      ${keyBinds}
      ${autoStart}
      ${winRules}
    '';
  };
}
