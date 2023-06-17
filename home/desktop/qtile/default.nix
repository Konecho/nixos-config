{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    (
      let
        python-packages = python-packages:
          with python-packages; [
            python-lsp-server
            autopep8
            black
            requests

            qtile
            qtile-extras
          ];
        pyEnv = python3.withPackages python-packages;
      in
        writeShellScriptBin "qtile" ''
          ${pyEnv}/bin/qtile start -b wayland \
          --config ${./config.py}
        ''
    )
  ];
}
