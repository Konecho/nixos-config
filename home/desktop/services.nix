{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # cage
    # xwayland-run
    # gamescope

    mpv
    lswt
  ];
  services.udiskie.enable = true;
  # services.ollama.enable = true;
  gtk.enable = true;
  ## [[mpvpaper]]
  systemd.user.sessionVariables.PATH = "${pkgs.systemd}:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin/";
  systemd.user.services.mpvpaper = lib.mkIf config.programs.mpvpaper.enable {
    Install = {WantedBy = [config.wayland.systemd.target];};
    Unit = {
      Description = "wallpaper program that allows you to play videos with mpv as your wallpaper";
      Documentation = ["man:mpvpaper(1)"];
    };
    Service = {
      ExecStart = ''
        ${lib.getExe pkgs.mpvpaper} -o "no-audio --loop-playlist shuffle input-ipc-server=/tmp/mpv-socket" \
        HDMI-A-1 ${config.home.xdg.userDirs.videos}/wallpapers
      '';
    };
  };
}
