{
  # sudo ln -s /home/flake/flake.nix /etc/nixos/flake.nix
  # sudo nixos-rebuild switch
  description = "A flake";

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
      username = "mei";
      hostname = "deskmini";
    in
    {
      homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          modules = [{
            home.username="${username}";
            # home.homeDirectory = "/home/${username}";
            imports = [ ./home ];
          }];
        };
      };
      nixosConfigurations = {
        "${hostname}" = nixpkgs.lib.nixosSystem {
          modules = [
            ./hardware-configuration.nix
            ./configuration.nix
            {
              imports = [ ./system ];
              networking.hostName = "${hostname}";
              users.users."${username}" = {
                isNormalUser = true;
                extraGroups = [ "wheel" "adbusers" "input" "networkmanager" ];
              };
            }
          ];
        };
      };
    };
}
