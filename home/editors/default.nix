{pkgs, ...}: {
  imports = [
    ./helix.nix
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
  programs = {
    vscode = {
      enable = true;
      # symlink to share vscode and codium settings
      # "~/.vscode/extensions" "~/.vscode-oss/extensions"
      # "~/.config/Code/User/settings.json" "~/.config/VSCodium/User/settings.json"
      package = pkgs.vscodium;
    };
  };
}
