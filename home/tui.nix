{
  pkgs,
  config,
  ...
}: {
  home.shellAliases.lf = "joshuto";
  home.packages = with pkgs; [
    # vtm
    sc-im # 表格
    mc # 文件管理
    calc

    termusic
  ];
  programs = {
    gitui = {
      enable = true;
    };
    joshuto = {
      enable = true;
      settings.preview.preview_script = pkgs.writeScript "pv.sh" ''
        #!/usr/bin/env bash
        IFS=$'\n'

        # Security measures:
        # * noclobber prevents you from overwriting a file with `>`
        # * noglob prevents expansion of wild cards
        # * nounset causes bash to fail if an undeclared variable is used (e.g. typos)
        # * pipefail causes a pipeline to fail also if a command other than the last one fails
        set -o noclobber -o noglob -o nounset -o pipefail

        FILE_PATH=""
        PREVIEW_WIDTH=10
        PREVIEW_HEIGHT=10

        while [ "$#" -gt 0 ]; do
        	case "$1" in
        	"--path")
        		shift
        		FILE_PATH="$1"
        		;;
        	"--preview-width")
        		shift
        		PREVIEW_WIDTH="$1"
        		;;
        	"--preview-height")
        		shift
        		PREVIEW_HEIGHT="$1"
        		;;
        	esac
        	shift
        done

        # ${pkgs.pistol}/bin/pistol "''${FILE_PATH}" && exit 0
        pistol "''${FILE_PATH}" "''${PREVIEW_WIDTH}" "''${PREVIEW_HEIGHT}" && exit 0
        # ${pkgs.ctpv}/bin/ctpv "''${FILE_PATH}" && exit 0
        exit 1
      '';
    };
    pistol = {
      enable = true;
      associations = [
        {
          mime = "image/*";
          # command = "${pkgs.exiftool}/bin/exiftool %pistol-filename% && ${pkgs.chafa}/bin/chafa -f symbols %pistol-filename%";
          command = "${pkgs.chafa}/bin/chafa -f symbols %pistol-filename%";
        }
        {
          mime = "video/*";
          command = "${pkgs.mediainfo}/bin/mediainfo %pistol-filename%";
        }
        {
          mime = "audio/*";
          command = "${pkgs.mediainfo}/bin/mediainfo %pistol-filename%";
        }
        {
          mime = "application/json";
          command = "sh: ${pkgs.jq}/bin/jq '.' %pistol-filename%";
        }
        {
          mime = "application/zip";
          command = "${pkgs.unzip}/bin/unzip -l %pistol-filename%";
        }
        {
          mime = "application/pdf";
          command = "${pkgs.poppler_utils}/bin/pdftotext -l 10 -nopgbrk -q -- %pistol-filename% - | fmt -w %pistol-extra0%";
        }
        {
          fpath = ".*.torrent$";
          command = "${pkgs.transmission}/bin/transmission-show %pistol-filename%";
        }
        {
          mime = "application/msword";
          command = "${pkgs.catdoc}/bin/catdoc %pistol-filename%";
        }
        {
          mime = "application/vnd.ms-excel";
          command = "${pkgs.catdoc}/bin/xls2csv %pistol-filename%";
        }
        {
          mime = "application/*";
          command = "${pkgs.hexyl}/bin/hexyl %pistol-filename%";
        }
        {
          mime = "text/plain";
          command = "sh: ${pkgs.bat}/bin/bat --paging=never --color=always --terminal-width=%pistol-extra0% %pistol-filename%";
        }
      ];
    };
    zellij.enable = true; # tmux
    # lf = {
    #   enable = true;
    #   previewer = {
    #     keybinding = "i";
    #     source = "${pkgs.pistol}/bin/pistol";
    #     # source = "${pkgs.ctpv}/bin/ctpv";
    #   };
    # };
  };
}
