{
  pkgs,
  rootPath,
  lib,
  config,
  inputs,
  ...
}: let
in {
  imports =
    map (p: rootPath + p) [
      /home/common.nix
      /home/nix.nix
      /home/git.nix

      /home/commandline/default.nix
    ]
    # ++ [inputs.agenix.homeManagerModules.default]
    ;
  programs.helix.settings.theme = "base16";
  programs.helix.themes.base16 = {
    inherits = "github_light";
    "ui.background" = {};
    "ui.statusline.normal" = {
      bg = "blue";
      fg = "white";
    };
  };
  home.packages = with pkgs; [
    # maple-mono.NF-CN
    wqy_zenhei
    # corefonts
    # vista-fonts

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
