{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ./utils.nix
    ./wallpapers.nix
  ];
  programs.vscode.userSettings = lib.mkForce {};

  # https://danth.github.io/stylix/options/hm.html
  stylix = {
    enable = true;
    # cursor = {
    #   package = pkgs.phinger-cursors;
    #   name = "phinger-cursors-${
    #     if config.stylix.polarity == "light"
    #     then "light"
    #     else "dark"
    #   }";
    #   size = 24;
    # };
    cursor = {
      package = pkgs.graphite-cursors;
      name = "graphite-${
        if config.stylix.polarity == "light"
        then "light"
        else "dark"
      }";
      size = 24;
    };
    opacity = {terminal = 0.85;};
    fonts = let
      MAPLE = {
        package = pkgs.maple-mono-SC-NF;
        name = "Maple Mono SC NF";
      };
      CC = {
        package = pkgs.cascadia-code;
        name = "Cascadia Code NF";
      };
      YAHEI = {
        package = pkgs.nur.repos.vanilla.Win10_LTSC_2021_fonts;
        name = "Microsoft YaHei";
      };
    in {
      serif = MAPLE;
      sansSerif = MAPLE;
      monospace = CC;
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets.vim.enable = false;
    targets.fish.enable = false;
  };
}
