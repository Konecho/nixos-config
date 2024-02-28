{
  pkgs,
  config,
  ...
}: {
  home.shellAliases.lf = "yazi";
  # home.shellAliases.lf = "joshuto";
  home.packages = with pkgs; [
    # vtm
    sc-im # 表格
    mc # 文件管理
    calc

    termusic

    yazi # ranger/lf/joshuto replacement
  ];
  programs = {
    gitui = {
      enable = true;
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
          command = "sh: ${pkgs.unzip}/bin/unzip -l %pistol-filename%";
        }
        {
          mime = "application/pdf";
          command = "sh: ${pkgs.poppler_utils}/bin/pdftotext -l 10 -nopgbrk -q -- %pistol-filename% - | fmt -w %pistol-extra0%";
        }
        {
          fpath = ".*.torrent$";
          command = "${pkgs.transmission}/bin/transmission-show %pistol-filename%";
        }
        {
          fpath = ".*.doc$";
          command = "${pkgs.catdoc}/bin/catdoc %pistol-filename%";
        }
        {
          fpath = ".*.xls$";
          command = "${pkgs.catdoc}/bin/xls2csv %pistol-filename%";
        }
        {
          mime = "text/*";
          command = "sh: ${pkgs.bat}/bin/bat --paging=never --color=always --terminal-width=%pistol-extra0% %pistol-filename%";
        }
        {
          mime = "application/*";
          command = "${pkgs.hexyl}/bin/hexyl -n 1kb %pistol-filename%";
        }
      ];
    };
    zellij = {
      # tmux
      enable = true;
      # enableFishIntegration = true;
      settings = {
        pane_frames = false;
        default_layout = "compact";
      };
    };
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
