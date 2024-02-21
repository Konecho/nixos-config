{
  # sudo nixos-rebuild switch
  description = "A flake";

  inputs = {
    # flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # gnomeNixpkgs.url = "github:NixOS/nixpkgs/gnome";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
    ags.url = "github:Aylur/ags";
    my-nixpkgs = {
      url = "github:Konecho/my-nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # joshuto = {
    #   url = "github:kamiyaa/joshuto";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # stylix = {
    #   url = "github:danth/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs"; # follow ghc
    #   inputs.home-manager.follows = "home-manager"; # follow ghc
    # };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    username = "mei";
    lib = import ./lib.nix inputs;

    pkgs = lib.mkPkgs {inherit system;};
  in {
    homeConfigurations."${username}" = lib.mkUsr {
      inherit pkgs username;
      modules = [
        ./home
      ];
    };

    nixosConfigurations = {
      deskmini = lib.mkSys {
        hostname = "deskmini";
        inherit username pkgs;
        modules = [
          (inputs.nixpkgs + "/nixos/modules/programs/wayland/wayland-session.nix")
          ./system
          ./hosts/deskmini/hardware-configuration.nix
        ];
      };
      chromebook = lib.mkSys {
        hostname = "chromebook";
        inherit username pkgs;
        modules = [
          ./hosts/chromebook/hardware-configuration.nix
          ./hosts/chromebook/configuration.nix
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
                ./home/editors/helix.nix
                ./home/commandline
                # ./home/nix.nix
                # ./home/desktop/fonts.nix
                # ./home/stylix.nix
              ];
            };
          }
        ];
      };
      wsl = lib.mkSys {
        hostname = "wsl";
        inherit username pkgs;
        modules = [
          inputs.nixos-wsl.nixosModules.wsl
          inputs.vscode-server.nixosModules.default
          ./hosts/wsl
          ./system/locale.nix
          ./system/misc.nix
          ./system/packages.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              home.stateVersion = "23.05";
              imports = [
                ./home/common.nix
                ./home/nix.nix
                ./home/editors/helix.nix
                ./home/commandline/git.nix
                ./home/commandline/shells.nix
                ./home/commandline/cli.nix
                ./home/commandline/tui.nix
              ];
            };
          }
        ];
      };
    };
  };
}
