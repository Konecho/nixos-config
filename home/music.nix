{
  pkgs,
  config,
  ...
}: {
  services.mpd.enable = true;
  home.packages = with pkgs; [
    termusic
    euphonica

    waylyrics
    netease-cloud-music-gtk
    adwaita-icon-theme

    pavucontrol
  ];
}
