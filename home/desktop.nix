{ pkgs, config, ... }:

rec {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./styles/hyprland.conf;
  };
  home.pointerCursor = {
    package = pkgs.comixcursors.Opaque_Orange;
    name = "ComixCursors-Opaque-Orange";
    size = 24;
    gtk.enable = true;
  };
  gtk = {
    enable = true;
    # cursorTheme = { };
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
  programs = {
    eww = {
      enable = true;
      package = pkgs.eww-wayland;
      configDir = ./.eww;
    };
  };
}
