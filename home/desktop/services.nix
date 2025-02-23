{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # niri
    cage
    xwayland-run
    xwayland-satellite
    gamescope

    activate-linux

    mpv
    # mpvpaper

    lswt
  ];
  programs.wpaperd.enable = true;
  programs.fuzzel.enable = true;
  services.mako = {
    enable = true;
    anchor = "top-center";
    defaultTimeout = 5;
    width = 450;
    height = 300;
  };
  services.cliphist.enable = true;
  programs.niri.settings.spawn-at-startup = [
    {command = ["clash-nyanpasu"];}
    {command = ["activate-linux"];}
    # {command = ["wezterm start -e btm"];}
    {command = ["mako"];}
    {command = ["fcitx5 -r -d"];}
    {command = ["wpaperd"];}
    {command = ["xwayland-satellite"];}
  ];

  gtk = {
    enable = true;
  };
  ## [[mpvpaper]]
  systemd.user.sessionVariables.PATH = "${pkgs.systemd}:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin/";
  # systemd.user.services.mpvpaper = {
  #   Install = {WantedBy = ["sway-session.target"];};
  #   Unit = {
  #     Description = "wallpaper program that allows you to play videos with mpv as your wallpaper";
  #     Documentation = ["man:mpvpaper(1)"];
  #   };
  #   Service = {
  #     ExecStart = ''
  #       ${pkgs.mpvpaper}/bin/mpvpaper -o "no-audio --loop-playlist shuffle input-ipc-server=/tmp/mpv-socket" \
  #       HDMI-A-1 ${config.home.homeDirectory}/media/video/wallpapers
  #     '';
  #   };
  # };
}
