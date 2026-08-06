{
  pkgs,
  lib,
  flake,
  ...
}: {
  imports = [
    flake.homeModules.identity
    flake.homeModules.common
    flake.homeModules.nix
    flake.homeModules.git
    flake.homeModules.commandline
  ];
  programs.helix.settings.theme = "base16";
  programs.helix.themes.base16 = {
    inherits = "github_light";
    "ui.background" = {};
    "ui.statusline.normal" = {
      bg = "blue";
      fg = "white";
    };
  };
  # 浅色主题，背景用终端色（vscode 白终端）
  programs.fresh-editor.settings = {
    theme = "light";
    editor.use_terminal_bg = true;
  };
  home.packages = with pkgs; [
    # maple-mono.NF-CN
    wqy_zenhei
    # corefonts
    # vista-fonts
    qutebrowser

    (python3.withPackages (
      p:
        with p; [
          pygments
          ptpython
          # xd deps
          beautifulsoup4
          requests
          prompt-toolkit
          wcwidth
          pyserial
          matplotlib
        ]
    ))
  ];
}
