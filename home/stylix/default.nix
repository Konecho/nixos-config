{
  pkgs,
  lib,
  config,
  ...
}: {
  # https://danth.github.io/stylix/options/hm.html

  stylix = let
    polarity = "dark"; # “either”, “light”, “dark”
  in {
    image = builtins.head (builtins.getAttr polarity (import ./wallpapers.nix pkgs));
    inherit polarity;
    opacity = {terminal = 0.95;};
    fonts = let
      MAPLE = {
        package = pkgs.maple-mono-SC-NF;
        name = "Maple Mono SC NF";
      };
      YAHEI = {
        package = pkgs.nur.repos.vanilla.Win10_LTSC_2021_fonts;
        name = "Microsoft YaHei";
      };
    in {
      serif = MAPLE;
      sansSerif = MAPLE;
      monospace = MAPLE;
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets.vim.enable = false;
  };
}
