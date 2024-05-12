{
  pkgs,
  config,
  ...
}: {
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/media/music";
    dataDir = "${config.home.homeDirectory}/.mpd";
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
  programs.ncmpcpp = {
    enable = true;
    settings = {
      # https://github.com/archcraft-os/archcraft-skeleton/blob/main/archcraft-config-music/files/.ncmpcpp/config
      mpd_crossfade_time = "2";

      ### Behaviour ###
      message_delay_time = 1;
      autocenter_mode = "yes";
      centered_cursor = "yes";
      ignore_leading_the = "yes";
      playlist_disable_highlight_delay = 2;
      allow_for_physical_item_deletion = "no";

      ### Visualizer ###;
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "mpd_visualizer";
      visualizer_in_stereo = "yes";
      visualizer_look = "●●";
      visualizer_type = "ellipse";

      ### Appearance ###;
      playlist_display_mode = "columns";
      colors_enabled = "yes";
      #user_interface       = classic;
      user_interface = "alternative";
      volume_color = "white";

      ### Window ###
      song_window_title_format = "{%a - }{%t}|{%f}";
      statusbar_visibility = "no";
      header_visibility = "no";
      titles_visibility = "no";

      ### Progress bar ###;
      progressbar_look = "▂▂▂";
      progressbar_color = "black";
      progressbar_elapsed_color = "yellow";

      ### Alternative UI ###;
      alternative_ui_separator_color = "black";
      # alternative_header_first_line_format = "$b$5$/b  $b$8 { %t }|{%f}$/b $/b ";
      # alternative_header_second_line_format = "{$b{$2  %a$9}{ - $7  %b$9}{ ($2%y$9)}}|{%D}";

      ### Song list ###
      song_status_format = "$7%t";
      song_list_format = "  %t $R%a %l  ";
      song_library_format = "{{%a - %t} (%b)}|{%f}";
      song_columns_list_format = "(53)[white]{tr} (45)[blue]{a}";

      ### Colors ###
      main_window_color = "blue";
      current_item_prefix = "$(blue)$r";
      current_item_suffix = "$/r$(end)";
      current_item_inactive_column_prefix = "red";
      current_item_inactive_column_suffix = "red";
      color1 = "white";
      color2 = "red";
    };
  };
  home.packages = with pkgs; [
    termusic
    waylyrics
    netease-cloud-music-gtk

    pavucontrol
  ];
}
