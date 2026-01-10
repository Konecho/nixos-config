{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.nix-index-database.homeModules.nix-index
    inputs.direnv-instant.homeModules.direnv-instant
  ];
  nix.registry = {
    n = {
      from = {
        id = "n";
        type = "indirect";
      };
      flake = inputs.nixpkgs;
    };
    m = {
      from = {
        id = "m";
        type = "indirect";
      };
      to = {
        owner = "Konecho";
        ref = "master";
        repo = "my-nixpkgs";
        type = "github";
      };
    };
  };
  programs = {
    home-manager.enable = true;
    nix-init.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    nix-your-shell.enable = true;
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    direnv-instant.enable = true;
    nh = {
      enable = true;
      flake = /etc/nixos;
    };
  };
  home.packages = with pkgs; [
    nix-tree
    nix-melt
    nix-diff
    nixfmt-rfc-style
    nil # lsp
    nixd
    nvd
    # rnix-lsp
    alejandra # formatter
    nvfetcher
    cachix

    nix-output-monitor # nom build/develop/shell
  ];
}
