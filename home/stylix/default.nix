{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
    ./wallpapers.nix
  ];

  # https://danth.github.io/stylix/options/hm.html
  stylix = {
    enable = true;
    cursor = {
      size = 24;
      #   package = pkgs.phinger-cursors;
      #   name = "phinger-cursors-${
      #     if config.stylix.polarity == "light"
      #     then "light"
      #     else "dark"
      #   }";
      package = pkgs.mypkgs.neuro-sama-cursor;
      name = "Neuro-sama";
      # cursor = {
      # package = pkgs.graphite-cursors;
      # name = "graphite-${
      #   if config.stylix.polarity == "light"
      #   then "light"
      #   else "dark"
      # }";
    };
    opacity = {
      terminal = 0.85;
    };
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
    # targets.fish.enable = false;
  };
}
