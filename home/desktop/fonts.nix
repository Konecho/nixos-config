{
  pkgs,
  rootPath,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    maple-mono.NF-CN
    # noto-fonts
    # noto-fonts-cjk-sans
    # noto-fonts-color-emoji
    # cascadia-code
    # monocraft
    # nur.repos.vanilla.Win10_LTSC_2021_fonts
    # nur.repos.vanilla.apple-fonts.NY
    wqy_zenhei
    corefonts
    vista-fonts
    vista-fonts-chs
    apl386
    ucs-fonts
    fira-mono
    fira-math
    # nerd-fonts.symbols-only

    noto-fonts
    noto-fonts-cjk-sans-static
    open-sans

    libertinus
    noto-fonts-cjk-serif-static

    cascadia-code
    maple-mono.NL-NF-CN-unhinted
    source-code-pro

    nerd-fonts.symbols-only
    noto-fonts-color-emoji
  ];
  fonts.fontconfig.configFile.default = {
    enable = true;
    label = "default";
    priority = 90;
    text =
      builtins.readFile (rootPath + /data/fonts.xml);
  };
}
