{pkgs, ...}: let
  # yazi 预览插件：读取 EPUB 的 container.xml/OPF，展示 meta 信息
  epub-meta-preview = pkgs.writeShellApplication {
    name = "epub-meta-preview";
    runtimeInputs = [pkgs.unzip pkgs.libxml2.bin];
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      if [ "$#" -lt 1 ] || [ ! -f "$1" ]; then
        printf '%s\n' "无法读取 EPUB 文件"
        exit 0
      fi
      epub="$1"

      container="$(unzip -p "$epub" META-INF/container.xml 2>/dev/null || true)"
      if [ -z "$container" ]; then
        printf '%s\n' "不是有效的 EPUB 文件（缺少 META-INF/container.xml）"
        exit 0
      fi

      opf="$(printf '%s' "$container" | sed -nE 's/.*full-path="([^"]+)".*/\1/p' | head -n1)"
      if [ -z "$opf" ]; then
        opf="OEBPS/content.opf"
      fi

      xml="$(unzip -p "$epub" "$opf" 2>/dev/null || true)"
      if [ -z "$xml" ]; then
        printf '未找到 OPF 文件：%s\n' "$opf"
        exit 0
      fi

      meta() {
        printf '%s' "$xml" | xmllint --xpath "string(//*[local-name()='$1'])" - 2>/dev/null || true
      }

      emit() {
        if [ -n "$2" ]; then
          printf '%s: %s\n' "$1" "$2"
        fi
      }

      printf '%s\n' "📖 $(basename "$epub")"
      printf '%s\n' "──────────────────────────────────────────"
      emit "标题" "$(meta title)"
      emit "作者" "$(meta creator)"
      emit "出版方" "$(meta publisher)"
      emit "日期" "$(meta date)"
      emit "语言" "$(meta language)"
      emit "标识符" "$(meta identifier)"
      emit "简介" "$(meta description)"
    '';
  };
in {
  programs.yazi = {
    enable = true;
    shellWrapperName = "lf";
    extraPackages = with pkgs; [
      glow
      ouch
      mediainfo
      hexyl
      trash-cli
      epub-meta-preview
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
              name = "*.epub";
              mime = "application/epub+zip";
              run = ''piper -- epub-meta-preview "$1"'';
            }
            {
              mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
              run = "ouch";
            }
          ];
        append_previewers = [
          {
            name = "*";
            mime = "*";
            run = ''piper -- hexyl --border=none --terminal-width=$w "$1"'';
          }
        ];
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            mime = "*";
            run = "git";
            group = "1";
          }
          {
            id = "git";
            name = "*/";
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
