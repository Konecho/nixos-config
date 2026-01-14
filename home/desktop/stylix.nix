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
    # autoEnable = false;
    polarity = "light";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
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
      monospace = MAPLE;
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };

    targets = {
      # managed by noctalia
      # ghostty.enable = false;
      noctalia-shell.enable = false;
      # niri.enable = false;
      #
      fish.enable = false;
      vscode.enable = false;
      # vscode.profileNames = ["stylix"];
      gtk.extraCss = ''
        window.background { border-radius: 0; }
      '';
      fcitx5.enable = false;
    };
  };
}
