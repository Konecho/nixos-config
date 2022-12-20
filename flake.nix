{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @{ self, nixpkgs, nixos-hardware, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations = {
        "mei" = home-manager.lib.homeManagerConfiguration {
          stateVersion = "22.11";
          inherit pkgs;
          configuration = { config, pkgs, ... }:
            {
              nixpkgs.config = {
                allowUnfree = true;
                # allowBroken = true;
              };
              imports = [
                ./home.nix
              ];
            };
        };
      };
      nixosConfigurations = {
        "deskmini" = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
