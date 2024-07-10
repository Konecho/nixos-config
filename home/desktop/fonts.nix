{pkgs, ...}: {
  fonts.fontconfig.enable = true;
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
    mypkgs.teranoptia
  ];
  # programs.alacritty.settings.font.normal.family = CC.name;
}
