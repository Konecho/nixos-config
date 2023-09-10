{pkgs, ...}: {
  home.packages = with pkgs; [
    ## [[misc]]
    ghc # Haskell
    tcl # Tcl/Tk

    ## [[my project]]
    # mypkgs.scutthesis.thesis

    ## [[python]]
    # conda
    # poetry
    (
      let
        python-packages = python-packages:
          with python-packages; [
            # pandas
            # pip
            # poetry-core

            python-lsp-server
            autopep8
            black

            requests

            # torchWithoutCuda
            # torchvision
            # ignite
            # opencv4
            # pandas
            # scikit-learn
            # numpy
            # einops
            # pillow
            # termplotlib
            # matplotlib

            # pyocd
            # adafruit-nrfutil
            # intelhex

            jupyterlab

            mypkgs.pokebase
          ];
        python-with-packages = python3.withPackages python-packages;
      in
        python-with-packages
    )

    ## [[rust]]
    rustup
    gcc
    qemu

    ## [[lsp]]
    nodePackages.bash-language-server
    cmake-language-server
    yaml-language-server
    #rust-analyzer
    texlab #latex
    taplo #toml

    # nrfconnect
    # segger-jlink

    gdb
  ];
}
