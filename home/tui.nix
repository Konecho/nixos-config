{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # vtm
    sc-im # 表格
    mc # 文件管理
    calc
    # gitui
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
        pistol "''${FILE_PATH}" && exit 0
        exit 1
      '';
    };
    pistol = {
      enable = true;
      associations = [
        {
          mime = "image/*";
          command = "${pkgs.chafa}/bin/chafa -f symbols %pistol-filename%";
        }
        {
          mime = "application/json";
          command = "sh: ${pkgs.jq}/bin/jq '.' %pistol-filename%";
        }
        {
          mime = "application/msword";
          command = "${pkgs.catdoc}/bin/catdoc %pistol-filename%";
        }
        {
          mime = "application/*";
          command = "${pkgs.hexyl}/bin/hexyl %pistol-filename%";
        }
        {
          fpath = ".*.md$";
          command = "sh: ${pkgs.bat}/bin/bat --paging=never --color=always %pistol-filename% | head -8";
        }
      ];
    };
    zellij.enable = true; # tmux
    lf = {
      enable = true;
      previewer = {
        keybinding = "i";
        source = "${pkgs.pistol}/bin/pistol";
        # source = "${pkgs.ctpv}/bin/ctpv";
      };
    };
  };
}
