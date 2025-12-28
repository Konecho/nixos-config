{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    maple-mono.NF-CN
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    cascadia-code
    # monocraft
    # nur.repos.vanilla.Win10_LTSC_2021_fonts
    # nur.repos.vanilla.apple-fonts.NY
    wqy_zenhei
    corefonts
    vista-fonts
    apl386
    ucs-fonts
    fira-mono
    fira-math
    nerd-fonts.symbols-only
  ];
}
