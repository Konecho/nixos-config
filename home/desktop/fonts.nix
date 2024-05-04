{pkgs, ...}: let
  MP = {
    package = pkgs.maple-mono-SC-NF;
    name = "Maple Mono SC NF";
  };
  CC = {
    package = pkgs.cascadia-code;
    name = "Cascadia Code PL";
  };
  YH = {
    package = pkgs.nur.repos.vanilla.Win10_LTSC_2021_fonts;
    name = "Microsoft YaHei";
  };
in {
  fonts.fontconfig.enable = true;
  gtk.font = MP;
  home.packages = with pkgs; [
    maple-mono-SC-NF
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    cascadia-code
    # monocraft
    # nur.repos.vanilla.Win10_LTSC_2021_fonts
    # nur.repos.vanilla.apple-fonts.NY
    # mypkgs.scutthesis.fonts.windows
    wqy_zenhei
  ];
  programs.alacritty.settings.font.normal.family = CC.name;
}
