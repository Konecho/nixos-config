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
  # gtk.font = MAPLE;
  stylix.fonts = {
    serif = YAHEI;
    sansSerif = YAHEI;
    monospace = MAPLE;
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
  home.packages = with pkgs; [
    # monocraft
    # nur.repos.vanilla.Win10_LTSC_2021_fonts
    # nur.repos.vanilla.apple-fonts.NY
    # mypkgs.scutthesis.fonts.windows
  ];
}
