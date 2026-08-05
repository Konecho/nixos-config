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
              # markdown 文件也用 glow 渲染（默认内置 code 预览器只做语法高亮）。
              # 官方 glow.yazi 插件已废弃，改用 piper + glow（与 epub 预览同一套路，
              # CLICOLOR_FORCE=1 强制非 TTY 下渲染 markdown，$t 是 piper 的明暗主题）。
              # glow 的 -w 只在空格处折行（纯中文不折），折行交给 piper 补丁后的 yazi 侧 wrap
              url = "*.md";
              run = "piper -- CLICOLOR_FORCE=1 glow -s=$t -w=0 \"$1\"";
            }
            {
              # epub 预览：exiftool 提取元信息（自带 EPUB 解析，不依赖 file(1) 的
              # mime 识别——container.xml 居首的非 OCF 标准 epub 也能读）→ jq 转成
              # markdown → glow 渲染样式。
              # 折行注意：glow -w 只在空格处折行（纯中文不折）且 `>` 引用块在 CJK 下
              # 渲染错乱（孤立竖线/宽度不一致），所以简介不用引用块、glow -w=0，
              # 折行交给 piper 补丁后的 yazi 侧 wrap（CJK 安全、自适应面板宽度）。
              # 不要写 mime = "application/epub+zip"：file(1) 5.48 只在 mimetype 是
              # 首个未压缩成员时识别为 EPUB document，其余 epub 会报 application/zip，
              # mime 条件会永远匹配不上而落到 ouch/hexyl。
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
      # piper 补丁：启用 yazi 侧折行（glow -w 只在空格处折行，纯中文不折；
      # yazi 的 Text wrap 是 CJK 安全且自适应预览面板宽度的）
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
