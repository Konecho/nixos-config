{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];
  nix.settings.tarball-ttl = 43200;
  # nix.settings.substituters = [
  #   "https://mirrors.ustc.edu.cn/nix-channels/store/"
  #   "https://cache.nixos.org/"
  # ];

  nix.registry = {
    old = {
      from = {
        id = "old";
        type = "indirect";
      };
      to = {
        owner = "NixOS";
        ref = "22.11";
        repo = "nixpkgs";
        type = "github";
      };
    };
    n = {
      from = {
        id = "n";
        type = "indirect";
      };
      flake = inputs.nixpkgs;
      # to = {
      #   owner = "NixOS";
      #   ref = "nixpkgs-unstable";
      #   repo = "nixpkgs";
      #   type = "github";
      # };
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
  programs.home-manager.enable = true;
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
  home.packages = with pkgs; [
    nix-init
    nix-tree
    nix-diff
    nil # lsp
    # rnix-lsp
    alejandra # formatter

    nix-output-monitor # nom build/develop/shell
  ];
}
