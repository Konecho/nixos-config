{
  # sudo nixos-rebuild switch
  description = "A flake";

  inputs = {
    # flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
    my-nixpkgs = {
      url = "github:Konecho/my-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    joshuto = {
      url = "github:kamiyaa/joshuto";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # stylix = {
    #   url = "github:danth/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs"; # follow ghc
    #   inputs.home-manager.follows = "home-manager"; # follow ghc
    # };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    username = "mei";
    hostname = "deskmini";
    lib = import ./lib.nix inputs;

    pkgs = lib.mkPkgs {inherit system;};
  in {
    homeConfigurations."${username}" = lib.mkUsr {
      inherit pkgs username;
      modules = [./home];
    };

    nixosConfigurations."${hostname}" = lib.mkSys {
      inherit hostname username pkgs;
      modules = [./system ./hardware-configuration.nix];
    };
  };
}
