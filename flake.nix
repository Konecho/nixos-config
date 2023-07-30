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
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
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
    hostname2 = "chromebook";
    lib = import ./lib.nix inputs;

    pkgs = lib.mkPkgs {inherit system;};
  in {
    homeConfigurations."${username}" = lib.mkUsr {
      inherit pkgs username;
      modules = [./home];
    };

    nixosConfigurations = {
      "${hostname}" = lib.mkSys {
        inherit hostname username pkgs;
        modules = [./system ./hardware-configuration.nix];
      };
      "${hostname2}" = lib.mkSys {
        hostname = hostname2;
        inherit username pkgs;
        modules = [
          ./chromebook/hardware-configuration.nix
          ./chromebook/configuration.nix
          ./system/lite.nix

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users."${username}" = {
              home.stateVersion = "23.05";
              imports = [
                # ./home/desktop/fcitx.nix
                # ./home/terminals/alacritty.nix
                # ./home/tui.nix
                ./home/desktop/dwl
                ./home/common.nix
                ./home/git.nix
                ./home/shells.nix
                ./home/editors/helix.nix
                ./home/cli.nix
                # ./home/nix.nix
                # ./home/desktop/fonts.nix
                # ./home/stylix.nix
              ];
            };
          }
        ];
      };
    };
  };
}
