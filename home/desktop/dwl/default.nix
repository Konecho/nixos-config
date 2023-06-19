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

  dwl-startup = builtins.concatStringsSep " <&- | " [
    "${pkgs.swww}/bin/swww init"
    "${pkgs.swww}/bin/swww img ${config.stylix.image}"
    "${pkgs.clash-verge}/bin/clash-verge"
  ];
in {
  home.packages = [
    (pkgs.writeShellScriptBin "dwl" ''
      systemctl --user status dwl-session.target
      exec ${cfgblocks}/bin/someblocks &
      ${cfgdwl}/bin/dwl -s "${cfgbar}/bin/somebar | ${dwl-startup}"
      rm $XDG_RUNTIME_DIR/somebar-*
      # clear
    '')
    pkgs.kickoff
  ];
  systemd.user.targets.dwl-session = {
    Unit = {
      Description = "dwl compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };
}
