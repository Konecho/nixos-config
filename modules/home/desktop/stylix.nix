{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  home.pointerCursor = {
    package = pkgs.mypkgs.neuro-sama-cursor;
    name = "Neuro-sama";
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };
  gtk = {
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Light";
    };
  };

  # https://danth.github.io/stylix/options/hm.html
  stylix = {
    enable = false;
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
        package = pkgs.maple-mono.NF-CN;
        name = "Maple Mono NF CN";
      };
      CC = {
        package = pkgs.cascadia-code;
        name = "Cascadia Code NF";
      };
      YAHEI = {
        package = pkgs.vista-fonts-chs;
        name = "Microsoft YaHei";
      };
    in {
      serif = MAPLE;
      sansSerif = YAHEI;
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
      # gtk.extraCss = ''
      #   window.background { border-radius: 0; }
      # '';
      gtk.enable = false;
      fcitx5.enable = false;
    };
  };
}
