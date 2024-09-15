{
  pkgs,
  config,
  ...
}: {
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
  programs.wpaperd.enable = true;
  home.packages = with pkgs; [
    swww # wallpaper
    mpv
    # mpvpaper
  ];
}
