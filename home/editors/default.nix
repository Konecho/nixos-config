{pkgs, ...}: {
  imports = [
    ./helix.nix
    ./vscode.nix
  ];
  home.packages = with pkgs; [
    ## [[lsp]]
    nodePackages.bash-language-server
    cmake-language-server
    yaml-language-server
    python3Packages.python-lsp-server
    #rust-analyzer
    texlab #latex
    taplo #toml
  ];
}
