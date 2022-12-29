{ pkgs, config, ... }:

rec {
  systemd.user.sessionVariables.PATH = "${pkgs.systemd}:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin/";
  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    config = rec {
      bars = [ ];
      menu = "rofi -show run";
      modifier = "Mod4";
      terminal = "kitty";
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
        "3: web" = [{ class = "^Microsoft-edge$"; window_role = "browser"; }];
        "2: code" = [{ class = "^Code$"; }];
        "1: term" = [{ app_id = "^kitty$"; }];
      };
      output = {
        HDMI-A-1 = {
          # bg = "~/.config/background fill";
        };
      };
    };
    extraSessionCommands = ''
      export XDG_CURRENT_DESKTOP=Unity
    '';
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
        name = "FiraCode Nerd Font";
      };
      settings = { background_opacity = "0.8"; window_border_width = "2px"; window_margin_width = 1; };
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
