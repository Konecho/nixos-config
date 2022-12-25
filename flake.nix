{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @{ self, nixpkgs, nixos-hardware, home-manager, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "microsoft-edge-stable"
          "vscode"
          "obsidian"
          "unrar"
        ];
      };
    in
    {
      homeConfigurations = {
        "mei" = home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
      nixosConfigurations = {
        "deskmini" = nixpkgs.lib.nixosSystem {
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
            ./network.nix
            ./locale.nix
            ./system-users.nix
          ];
        };
      };
    };
}
