{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "lf";
    extraPackages = with pkgs; [
      glow
      ouch
      mediainfo
      hexyl
      trash-cli
    ];
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
          map (x: {
            mime = x;
            run = "mediainfo";
          }) [
            "{audio,video,image}/*"
            "application/subrip"
            "application/postscript"
          ];
      in {
        prepend_preloaders = media-info-mime;
        prepend_previewers =
          media-info-mime
          ++ [
            {
              mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
              run = "ouch";
            }
          ];
        append_previewers = [
          {
            name = "*";
            run = ''piper -- hexyl --border=none --terminal-width=$w "$1"'';
          }
        ];
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
    plugins = {
      inherit
        (pkgs.yaziPlugins)
        chmod
        starship
        mediainfo
        full-border
        git
        smart-filter
        piper
        ouch
        recycle-bin
        restore
        ;
    };

    initLua = ''
      require("full-border"):setup()
      require("starship"):setup()
      require("git"):setup()
      require("recycle-bin"):setup()
    '';

    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["c" "m"];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "F";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
        {
          on = ["C"];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
        {
          on = ["R" "b"];
          run = "plugin recycle-bin";
          desc = "Open Recycle Bin menu";
        }
        {
          on = "u";
          run = "plugin restore";
          desc = "Restore last deleted files/folders";
        }
      ];
    };
  };
}
