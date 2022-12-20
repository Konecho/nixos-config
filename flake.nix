{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @{ self, nixpkgs, nixos-hardware, home-manager, ... }:
    let system = "x86_64-linux"; # arm64-linux
    in
    {
      homeConfigurations = (
        let
          username = "mei";
          homeDirectory = "/home/${username}";
          configHome = "${homeDirectory}/.config";

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.xdg.configHome = configHome;
            # overlays = [ nurpkgs.overlay ];
          };
        in
        {
          main = home-manager.lib.homeManagerConfiguration rec {
            inherit pkgs system username homeDirectory;

            stateVersion = "22.11";
            configuration = import ./home.nix {
              inherit pkgs;
              inherit (pkgs) config lib stdenv;
            };
          };
        }
      );
      nixosConfigurations."deskmini" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
        ];
      };
    };
}
