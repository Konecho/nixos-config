{ pkgs, config, ... }:

rec {
  gtk = {
    enable = true;
    cursorTheme = { name = "Vanilla-DMZ"; package = pkgs.vanilla-dmz; };
    theme = {
      name = "Pop";
      package = pkgs.pop-gtk-theme;
    };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-solarized-gtk-theme;
    };
  };
  systemd.user.sessionVariables.PATH = "${pkgs.systemd}:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin/";
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    config = {
      bars = [ ];
      # bars = [{
      #   fonts = {
      #     names = [ "FiraCode Nerd Font" ];
      #     style = "Bold Semi-Condensed";
      #     size = 11.0;
      #   };
      #   position = "bottom";
      #   statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.home.homeDirectory}/.config/i3status-rust/config-bottom.toml";
      #   colors = {
      #     separator = "#666666";
      #     background = "#222222";
      #     statusline = "#dddddd";
      #     focusedWorkspace = {
      #       background = "#285577";
      #       border = "#4c7899";
      #       text = "#ffffff";
      #     };
      #     activeWorkspace = {
      #       background = "#5f676a";
      #       border = "#333333";
      #       text = "#ffffff";
      #     };
      #     inactiveWorkspace = {
      #       background = "#222222";
      #       border = "#333333";
      #       text = "#888888";
      #     };
      #     urgentWorkspace = {
      #       background = "#900000";
      #       border = "#2f343a";
      #       text = "#ffffff";
      #     };
      #   };
      # }];
      menu = "rofi -show run";
      modifier = "Mod4";
      terminal = "alacritty";
      startup = [
        { command = "systemctl --user restart waybar"; always = true; }
        { command = "systemctl --user restart swayidle"; always = true; }
        { command = "systemctl --user restart mpd"; always = true; }
        # { command = "systemctl --user restart fcitx5-daemon"; always = true; }
        { command = "fcitx5 -d --replace"; always = true; }
        { command = "starship preset plain-text-symbols > ~/.config/starship.toml"; }
        # { command = "kitty"; }
      ];
      assigns = {
        # https://i3wm.org/docs/userguide.html#command_criteria
        # <swaymsg -t get_tree>
        # <nix run nixpkgs#wlprop>
        # "1: term" = [{ app_id = "^kitty$"; }];
        # "2: code" = [{ class = "^Code$"; }];
        # "3: web" = [{ class = "^Microsoft-edge$"; window_role = "browser"; }];
      };
      input."type:keyboard" = {
        xkb_numlock = "enabled";
      };
      output = {
        HDMI-A-1 = {
          # bg = "${pkgs.nixos-artwork.wallpapers.dracula.gnomeFilePath} fill";
        };
      };
    };
    extraConfig = ''exec_always autotiling'';
    extraSessionCommands = ''
      # export XDG_CURRENT_DESKTOP=Unity
    '';
  };
  systemd.user.services.mpvpaper = {
    Install = { WantedBy = [ "sway-session.target" ]; };
    Unit = {
      Description = "wallpaper program that allows you to play videos with mpv as your wallpaper";
      Documentation = [ "man:mpvpaper(1)" ];
    };
    Service = {
      ExecStart = ''
        ${pkgs.mpvpaper}/bin/mpvpaper -o "no-audio --loop-playlist shuffle input-ipc-server=/tmp/mpv-socket" \
        HDMI-A-1 ${config.home.homeDirectory}/media/video/wallpapers
      '';
    };
  };
  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -c 000000"; }
      { event = "after-resume"; command = "swaymsg \"output * dpms on\""; }
    ];
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -fF -c 000000"; }
      { timeout = 360; command = "swaymsg \"output * dpms off\""; }
    ];
  };
  programs = {
    i3status-rust = {
      enable = false;
      bars.bottom = {
        blocks = [
          {
            block = "disk_space";
            path = "/nix/store";
            alias = "/nix/store";
            info_type = "available";
            unit = "GB";
            interval = 60;
            warning = 10.0;
            alert = 5.0;
          }
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_used_percents}";
            format_swap = "{swap_used_percents}";
          }
          {
            block = "cpu";
            interval = 1;
          }
          # {
          #   block = "load";
          #   interval = 1;
          #   format = "{1m}";
          # }
          { block = "sound"; }
          {
            block = "time";
            interval = 60;
            format = "%a %d/%m %R";
          }
        ];
        settings = {
          theme = {
            name = "gruvbox-dark";
            # overrides = {
            #   idle_bg = "#123456";
            #   idle_fg = "#abcdef";
            # };
          };
          icons.overrides = { cpu = ""; };
        };
        icons = "awesome5";
        # theme = "gruvbox-dark";
      };
    };
    rofi = {
      enable = true;
      # https://github.com/adi1090x/rofi
      theme = ./styles/rofi.rasi;
    };
    waybar = {
      enable = true;
      systemd = {
        enable = true;
        # target = "sway-session.target";
      };
      style = ./styles/waybar.css;
      settings = {
        mainBar = builtins.fromJSON (builtins.readFile ./styles/waybar.json);
      };
    };
    kitty = {
      enable = true;
      font = {
        size = 12;
        name = "Maple Mono SC NF";
      };
      settings = { background_opacity = "0.8"; window_border_width = "2px"; window_margin_width = 1; };
    };
    alacritty = {
      enable = true;
      settings = {
        opacity = 0.8;
        font.normal.family = "Maple Mono SC NF";
        font.size = 12;
      };
    };
    # swaylock.settings = {
    #   color = "808080";
    #   font-size = 24;
    #   indicator-idle-visible = false;
    #   indicator-radius = 100;
    #   line-color = "ffffff";
    #   show-failed-attempts = true; #-F
    # };
  };
}
