{
  pkgs,
  config,
  ...
}: {
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "pulse"
        name "pulse audio"
      }
      audio_output {
      	type                    "fifo"
      	name                    "my_fifo"
      	path                    "/tmp/mpd.fifo"
      	format                  "44100:16:2"
      }
    '';
  };
  home.packages = with pkgs; [
    termusic
    waylyrics
    netease-cloud-music-gtk
    adwaita-icon-theme

    pavucontrol
  ];
}
