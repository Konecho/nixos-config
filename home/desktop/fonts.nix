{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  # gtk.font = {
  #   package = pkgs.maple-mono-SC-NF;
  #   name = "Maple Mono SC NF";
  # };
  stylix.fonts = {
    serif = {
      package = pkgs.noto-fonts-cjk;
      name = "Noto Serif CJK SC";
    };
    # 无衬线
    sansSerif = {
      package = pkgs.nur.repos.vanilla.Win10_LTSC_2021_fonts;
      name = "Microsoft YaHei";
    };

    monospace = {
      package = pkgs.maple-mono-SC-NF;
      name = "Maple Mono SC NF";
    };

    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
  home.packages = with pkgs; [
    monocraft
    nur.repos.vanilla.Win10_LTSC_2021_fonts
    # nur.repos.vanilla.apple-fonts.NY
    mypkgs.scutthesis.fonts.windows
  ];
}
