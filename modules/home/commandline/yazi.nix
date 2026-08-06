{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "lf";
    # epub 预览用 exiftool + jq + glow（见 prepend_previewers 规则），不新增自写脚本
    extraPackages = with pkgs; [
      glow
      exiftool
      jq
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
              # markdown 用 piper + glow 渲染（官方 glow.yazi 已废弃；CLICOLOR_FORCE=1 强制
              # 非 TTY 渲染，$t 为明暗主题；-w 只在空格折行，折行交 piper 补丁后的 yazi wrap）
              url = "*.md";
              run = "piper -- CLICOLOR_FORCE=1 glow -s=$t -w=0 \"$1\"";
            }
            {
              # epub 预览：exiftool 自带 EPUB 解析（container.xml 居首的非标准 epub 也能读，
              # 不依赖 file(1) mime）→ jq 转 markdown → glow 渲染。
              # 规则勿写 mime：file(1) 对非 OCF 结构 epub 识别为 application/zip，mime 永不匹配
              # 折行：glow -w 只在空格折行、`>` 引用块 CJK 渲染错乱，故 -w=0、不用引用块，
              # 折行交 piper 补丁后的 yazi wrap（CJK 安全）
              url = "*.epub";
              run = "piper -- exiftool -json \"$1\" | jq -r '.[0] | \"# \\(.Title)\\n\\n**作者**: \\(.Creator // \"\")\\n**语言**: \\(.Language // \"\")\\n**标识符**: \\(.Identifier // \"\")\\n\\n\\(.Description // \"\")\"' | CLICOLOR_FORCE=1 glow -s=$t -w=0";
            }
            {
              mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
              run = "ouch";
            }
          ];
        append_previewers = [
          {
            url = "*";
            mime = "*";
            run = ''piper -- hexyl --border=none --terminal-width=$w "$1"'';
          }
        ];
        prepend_fetchers = [
          {
            id = "git";
            url = "*";
            mime = "*";
            run = "git";
            group = "1";
          }
          {
            id = "git";
            url = "*/";
            mime = "*";
            run = "git";
            group = "1";
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
        ouch
        recycle-bin
        restore
        ;
      # piper 补丁：启用 yazi 侧折行（glow -w 只在空格折行；yazi Text wrap CJK 安全）
      piper = pkgs.yaziPlugins.piper.overrideAttrs (old: {
        patches = [./piper-wrap.patch];
      });
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
