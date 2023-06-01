{pkgs, ...}: {
  home.packages = with pkgs; [
    # vtm
    sc-im # 表格
    mc # 文件管理
    calc
    # gitui
  ];
  programs.gitui = {
    enable = true;
  };
}
