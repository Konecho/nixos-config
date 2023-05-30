{pkgs, ...}: {
  home.packages = with pkgs; [
    ## [[my project]]
    mypkgs.scutthesis.thesis

    ## [[python]]
    # conda
    poetry
    # (
    #   let
    #     python-packages = python-packages:
    #       with python-packages; [
    #         # pandas
    #         pip
    #         python-lsp-server
    #         autopep8
    #         requests
    #         # poetry-core
    #       ];
    #     python-with-packages = python3.withPackages python-packages;
    #   in
    #     python-with-packages
    # )

    ## [[rust]]
    rustup
    gcc
    qemu

    ## [[lsp]]
    nodePackages.bash-language-server
    cmake-language-server
    #rust-analyzer
    texlab #latex
    taplo #toml
  ];
}
