{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  # https://danth.github.io/stylix/options/hm.html
  stylix = {
    enable = true;
    polarity = "light";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/google-light.yaml";
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
    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      light = "Papirus-Light";
      dark = "Papirus-Dark";
    };
    opacity = {
      terminal = 0.85;
    };
    fonts = let
      MAPLE = {
        # package = pkgs.maple-mono.CN;
        # name = "Maple Mono CN";
        package = pkgs.maple-mono.NF-CN;
        name = "Maple Mono NF CN";
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
    # targets.vscode.enable = false;
    targets.vscode.profileNames = ["stylix"];
    targets.gtk.extraCss = ''
      window.background { border-radius: 0; }
    '';
    targets.fcitx5.enable = false;
  };
}
