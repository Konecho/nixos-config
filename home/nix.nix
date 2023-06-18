{
  pkgs,
  config,
  ...
}: {
  nix.package = pkgs.nix;
  nix.settings.tarball-ttl = 43200;
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
      flake = config.nix.registry.nixpkgs.flake;
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
  home.packages = with pkgs; [
    ## [[nix]]
    nix-init
    nix-tree
    nil
    # rnix-lsp
    alejandra
  ];
}
