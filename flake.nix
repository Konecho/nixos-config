{
  description = "A flake";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    preservation.url = "github:nix-community/preservation";
    nur.url = "github:nix-community/NUR";
    my-nixpkgs = {
      url = "github:Konecho/my-nixpkgs";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
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
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    nixgl.url = "github:guibou/nixGL";
    stylix.url = "github:danth/stylix";
    pokesprite = {
      url = "github:msikma/pokesprite";
      flake = false;
    };
    niri.url = "github:sodiboo/niri-flake";
    # gBar.url = "github:scorpion-26/gBar";
    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };
    dank.url = "github:AvengeMedia/DankMaterialShell";
    ironbar = {
      url = "github:JakeStanger/ironbar";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    yazi-starship = {
      url = "github:Rolv-Apneseth/starship.yazi";
      flake = false;
    };
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
  };

  outputs = inputs: let
    system = "x86_64-linux";
    username = "mei";
    lib = import ./lib.nix inputs;

    pkgs = lib.mkPkgs {inherit system;};
    pkgs-fix-gl = lib.mkPkgs {
      inherit system;
      overlays = [
        (self: super: rec {
          # mesa = inputs.nixpkgs-stable.legacyPackages."${system}".mesa; # to fix errors below in <glxinfo>
          ## MESA: error: ZINK: failed to choose pdev
          ## glx: failed to create drisw screen
          ## failed to load driver: zink
        })
        inputs.nixgl.overlay
      ];
    };
  in {
    homeConfigurations."${username}" = lib.mkUsr {
      inherit pkgs username;
      modules = lib.scanPath {
        path = ./home;
        # excludeFiles = ["stylix"];
      };
    };

    nixosConfigurations = {
      deskmini = lib.mkSys {
        hostname = "deskmini";
        inherit username pkgs system;
        modules =
          [
            # (inputs.nixpkgs + "/nixos/modules/programs/wayland/wayland-session.nix")
            ./hosts/deskmini/hardware-configuration.nix
          ]
          ++ (lib.scanPath {path = ./system;});
      };
      wsl = lib.mkSys {
        hostname = "wsl";
        pkgs = pkgs-fix-gl;
        # inherit pkgs;
        inherit username system;
        modules = [
          ./hosts/wsl/system.nix
        ];
        hm-modules = [
          ./hosts/wsl/home.nix
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        hello
      ];
    };
    formatter.${system} = pkgs.alejandra;
  };
}
