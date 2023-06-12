{
  pkgs,
  config,
  ...
}: let
  # https://git.sr.ht/~raphi/someblocks
  cfgblocks = pkgs.mypkgs.someblocks.override {
    conf = ./blocks.def.h;
  };

  # https://github.com/djpohly/dwl
  cfgdwl = pkgs.dwl.override {
    conf = ./dwl.def.h;
    # conf = fetchurl {
    #   url = "https://raw.githubusercontent.com/djpohly/dwl/main/config.def.h";
    #   sha256 = "sha256-yyN7G98GBVPmwOM+QZfh/Uq8tWLSI0J+hgbtcKvIjwM=";
    # };
    # patches = [
    #   (fetchMercurial {
    #     url = "https://github.com/djpohly/dwl/compare/main...DanielMowitz:bottomstack.patch";
    #     sha256 = "sha256-L5eNXPEHLM0D4PEjPqyvCAp9DRQYpOXKwUCvdCnJsJQ=";
    #   })
    # ];
  };

  # https://git.sr.ht/~raphi/somebar
  cfgbar = pkgs.somebar.override {
    conf = ./bar.def.hpp;
  };
in {
  home.packages = [
    (pkgs.writeShellScriptBin "dwl" ''
      # exec fcitx5 -d &
      exec ${pkgs.swww}/bin/swww init &
      exec ${pkgs.swww}/bin/swww img ${config.stylix.image} &
      # exec ${pkgs.clash-verge}/bin/clash-verge &
      exec ${cfgblocks}/bin/someblocks &
      ${cfgdwl}/bin/dwl -s ${cfgbar}/bin/somebar
      rm $XDG_RUNTIME_DIR/somebar-*
      clear
    '')
  ];
}
