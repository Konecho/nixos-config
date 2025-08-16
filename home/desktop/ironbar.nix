{
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [inputs.ironbar.homeManagerModules.default];
  programs.niri.settings = {
    spawn-at-startup = [
      {command = ["ironbar"];}
    ];
  };
  programs.ironbar = {
    enable = true;
    systemd = false; # not support niri
    config = {
      anchor_to_edges = true;
      position = "bottom";
      icon_theme = "Paper";
      start = [
        # {
        #   type = "launcher";
        #   favorites = [
        #     # "librewolf",
        #     # "vscodium",
        #     # "wezterm",
        #   ];
        #   show_names = false;
        #   show_icons = true;
        # }
        {
          type = "workspaces";
          # name_map."1" = "";
          # name_map."2" = "";
          # name_map."3" = "";
          # favorites = ["1" "2" "3"];
          # all_monitors = false;
          # sort = "name";
        }
        {
          type = "focused";
          truncate = "end";
        }
      ];
      end = [
        # {
        #   type = "music";
        #   player_type = "mpd";
        #   music_dir = "/home/mei/media/music";
        #   truncate = {
        #     mode = "end";
        #     max_length = 100;
        #   };
        # }
        {
          type = "music";
          player_type = "mpd";
          host = "127.0.0.1:6600";
          truncate = "end";
        }
        {
          type = "sys_info";
          format = [
            # " {cpu_percent}% | {temp_c:k10temp_Tccd1}°C"
            " {memory_used}/{memory_total} GB ({memory_percent}%)"
            # "| {swap_used} / {swap_total} GB ({swap_percent}%)"
            # "󰋊 {disk_used:/nix}/{disk_total:/nix} GB ({disk_percent:/nix}%)"
            "󰓢 {net_up@wlp4s0}/{net_down@wlp4s0} Mbps"
            "󰖡 {load_average_1}"
            # "󰥔 {uptime}"
          ];
          interval = {
            memory = 30;
            cpu = 1;
            temps = 5;
            disks = 300;
            networks = 3;
          };
        }
        {
          type = "tray";
        }
        {
          type = "volume";
          format = "{icon} {percentage}%";
          max_volume = 100;
          icons = {
            volume_high = "󰕾";
            volume_medium = "󰖀";
            volume_low = "󰕿";
            muted = "󰝟";
          };
        }
        {
          type = "clipboard";
          max_items = 5;
          truncate = {
            mode = "end";
            length = 50;
          };
        }
        {
          "type" = "custom";
          "class" = "power-menu";
          "bar" = [
            {
              "type" = "button";
              "name" = "power-btn";
              "label" = "";
              "on_click" = "popup:toggle";
            }
          ];
          "popup" = [
            {
              "type" = "box";
              "orientation" = "vertical";
              "widgets" = [
                {
                  "type" = "label";
                  "name" = "header";
                  "label" = "Power menu";
                }
                {
                  "type" = "box";
                  "widgets" = [
                    {
                      "type" = "button";
                      "class" = "power-btn";
                      "label" = "<span font-size='40pt'></span>";
                      "on_click" = "!shutdown now";
                    }
                    {
                      "type" = "button";
                      "class" = "power-btn";
                      "label" = "<span font-size='40pt'></span>";
                      "on_click" = "!reboot";
                    }
                  ];
                }
                {
                  "type" = "label";
                  "name" = "uptime";
                  "label" = "Uptime: {{uptime|hck -d'[\\s]' -f 2}}";
                }
              ];
            }
          ];
        }
        {
          type = "clock";
          format = "%Y/%m/%d %H:%M";
        }
      ];
    };
    style = "";
    package = inputs.ironbar.packages.x86_64-linux.default;
    # features = ["feature" "another_feature"];
  };
}
