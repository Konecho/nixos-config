{
  pkgs,
  inputs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    mediainfo
  ];
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "lf";
    settings = {
      mgr = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };

      plugin = let
        media-info-mime =
          builtins.map (x: {
            mime = x;
            run = "mediainfo";
          }) [
            "{audio,video,image}/*"
            "application/subrip"
            "application/postscript"
          ];
      in {
        prepend_preloaders = media-info-mime;
        prepend_previewers = media-info-mime;
        append_previewers =[ {
          name = "*";
          run = ''piper -- ${pkgs.hexyl}/bin/hexyl --border=none --terminal-width=$w "$1"'';
        }];
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
      };
    };
    plugins = let
      yazi-plugins = inputs.yazi-plugins;
      yazi-starship = inputs.yazi-starship;
      yazi-mediainfo = inputs.yazi-mediainfo;
    in {
      chmod = "${yazi-plugins}/chmod.yazi";
      full-border = "${yazi-plugins}/full-border.yazi";
      max-preview = "${yazi-plugins}/max-preview.yazi";
      git = "${yazi-plugins}/git.yazi";
      smart-filter = "${yazi-plugins}/smart-filter.yazi";
      piper = "${yazi-plugins}/piper.yazi";
      starship = yazi-starship;
      mediainfo = yazi-mediainfo;
    };

    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
      require("git"):setup()
    '';

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "T";
          run = "plugin max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "F";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
      ];
    };
  };
}
