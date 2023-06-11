{pkgs, ...}: let
  mkBlocks = pathToConfig:
    pkgs.stdenv.mkDerivation {
      name = "someblocks";

      src = pkgs.fetchFromSourcehut {
        owner = "~raphi";
        repo = "someblocks";
        rev = "1.0.1";
        sha256 = "sha256-pUdiEyhqLx3aMjN0D0y0ykeXF3qjJO0mM8j1gLIf+ww=";
      };

      postPatch = "cp ${pathToConfig} blocks.def.h";

      NIX_CFLAGS_COMPILE = [
        "-Wno-error=unused-result"
      ];

      installPhase = ''
        runHook preInstall
        install -d $out/bin
        install -m755 someblocks $out/bin
        runHook postInstall
      '';
    };
in {
  home.packages = with pkgs; [
    # https://github.com/djpohly/dwl
    (dwl.override {
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
    })

    # https://git.sr.ht/~raphi/somebar
    (somebar.override {
      conf = ./bar.def.hpp;
    })
    # somebar

    # https://git.sr.ht/~raphi/someblocks
    (mkBlocks ./blocks.def.h)

    (writeShellScriptBin "dwlrun" ''
      exec someblocks &
      dwl -s "clash-verge & mako & fcitx5 -d & somebar "
      rm $XDG_RUNTIME_DIR/somebar-*
      clear
    '')
  ];
}
