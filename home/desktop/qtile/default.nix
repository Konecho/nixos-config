{
  pkgs,
  config,
  ...
}:
with pkgs; let
  extra-packages = ps:
    with ps; [
      qtile
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
        exec_once("${pkgs.swww}/bin/swww init")
        exec_once("${pkgs.swww}/bin/swww img ${config.stylix.image}")
        # exec_once("${pkgs.mypkgs.pokemon-terminal}/bin/pokemon -w 615")
        exec_once("${pkgs.clash-verge}/bin/clash-verge")
        exec_once("${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start qtile-session.target")
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
        #!/bin/sh
        PYTHONPATH=${pyEnv}/${pyEnv.sitePackages}:$PYTHONPATH ${pyEnv}/bin/qtile start -b wayland #--config "${cfgFile}"
      ''
    )
    (
      writeShellScriptBin "qtile-check" ''
        #!/bin/sh
        PYTHONPATH=${pyEnv}/${pyEnv.sitePackages}:$PYTHONPATH ${pyEnv}/bin/qtile check #--config ${cfgFile}
      ''
    )
    (
      writeShellScriptBin "qtile-test" ''
        #!/bin/sh
        PYTHONPATH=${pyEnv}/${pyEnv.sitePackages}:$PYTHONPATH ${pyEnv}/bin/qtile start -b wayland --config /etc/nixos/home/desktop/qtile/config.py
      ''
    )
  ];
  home.file.qtile-config = {
    text = cfgText;
    target = ".config/qtile/config.py";
  };

  systemd.user.targets.qtile-session = {
    Unit = {
      Description = "qtile compositor session";
      Documentation = ["man:systemd.special(7)"];
      BindsTo = ["graphical-session.target"];
      Wants = ["graphical-session-pre.target"];
      After = ["graphical-session-pre.target"];
    };
  };
}
