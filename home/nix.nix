{pkgs, ...}: {
  nix.package = pkgs.nix;
  nix.settings.tarball-ttl = 43200;
  nix.registry = {
    n = {
      # flake = pkgs;
      from = {
        id = "n";
        type = "indirect";
      };
      to = {
        owner = "NixOS";
        ref = "nixpkgs-unstable";
        repo = "nixpkgs";
        type = "github";
      };
    };
    m = {
      # flake = pkgs;
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
    nil
    # rnix-lsp
    alejandra
  ];
}
