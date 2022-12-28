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
  services.mpd = { enable = true; musicDirectory = "${config.home.homeDirectory}/media/music"; };
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
      theme = "gruvbox-dark-soft";
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
