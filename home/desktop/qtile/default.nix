{
  pkgs,
  config,
  ...
}:
with pkgs; let
  qtile-package = qtile.unwrapped;
  extra-packages = ps:
    with ps;
      [qtile-package]
      ++ [
        python-lsp-server
        autopep8
        black
        mypy
        requests
        qtile-extras
      ];
  pyEnv = python3.withPackages extra-packages;
  cfgText = ''
    ${builtins.readFile ./config.py}
    # start the applications at Qtile startup
    @hook.subscribe.startup
    def startup():
        exec_once("${pkgs.swww}/bin/swww init &")
        exec_once("${pkgs.swww}/bin/swww img ${config.stylix.image} &")
        # exec_once("${pkgs.mypkgs.pokemon-terminal}/bin/pokemon -w 615 &")
        exec_once("${pkgs.clash-verge}/bin/clash-verge &")
  '';
  cfgFile = writeScript "config.py" cfgText;
  # cfgFile = fetchurl {
  #   url = "https://raw.githubusercontent.com/qtile/qtile/master/libqtile/resources/default_config.py";
  #   sha256 = "sha256-R6ZzYq28g6lDXlnGCq5SMhuaQ+XkvJcZ9BP5qtpduBM=";
  # };
in {
  home.packages = [
    (
      writeShellScriptBin "qtile-run" ''
        ${pyEnv}/bin/qtile start -b wayland --config "${cfgFile}" & waitPID=\$!
      ''
    )
    (
      writeShellScriptBin "qtile-check" ''
        ${pyEnv}/bin/qtile check --config ${cfgFile}
      ''
    )
  ];
  home.file.qtile-config = {
    text = cfgText;
    target = ".config/qtile/config.py";
  };
}
