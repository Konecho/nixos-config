{pkgs, ...}: let
  MAPLE = {
    package = pkgs.maple-mono-SC-NF;
    name = "Maple Mono SC NF";
  };
  YAHEI = {
    package = pkgs.nur.repos.vanilla.Win10_LTSC_2021_fonts;
    name = "Microsoft YaHei";
  };
in {
  fonts.fontconfig.enable = true;
  gtk.font = MAPLE;
  home.packages = with pkgs; [
    maple-mono-SC-NF
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    # monocraft
    # nur.repos.vanilla.Win10_LTSC_2021_fonts
    # nur.repos.vanilla.apple-fonts.NY
    # mypkgs.scutthesis.fonts.windows
  ];
}
