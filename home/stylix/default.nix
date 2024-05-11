{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.stylix.homeManagerModules.stylix];
  # https://danth.github.io/stylix/options/hm.html

  stylix = let
    polarity = "dark"; # “either”, “light”, “dark”
  in {
    image = builtins.head (builtins.getAttr polarity (import ./wallpapers.nix pkgs));

    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-${
        if polarity == "light"
        then "light"
        else "dark"
      }";
      size = 24;
    };
    inherit polarity;
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
  };
}
