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
      settings.preview.preview_script = "${pkgs.pistol}/bin/pistol";
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
