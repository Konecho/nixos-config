{
  description = "A flake";
  inputs = {
    # not follow
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
    preservation.url = "github:nix-community/preservation";
    my-nixpkgs.url = "github:Konecho/my-nixpkgs";
    # follow nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nur.follows = "";
    };
    direnv-instant = {
      url = "github:Mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:visualglitch91/niri/feat/blur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minegrub-theme = {
      url = "github:Lxtharia/minegrub-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minegrub-world-sel-theme = {
      url = "github:Lxtharia/minegrub-world-sel-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minecraft-plymouth-theme = {
      url = "github:nikp123/minecraft-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    minesddm = {
      url = "github:Davi-S/sddm-theme-minesddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia = {
      url = "github:jutraim/niri-caelestia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
    hexecute = {
      url = "github:ThatOtherAndrew/Hexecute";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jj-starship = {
      url = "github:dmmulroy/jj-starship";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # not flake
    pokesprite = {
      url = "github:msikma/pokesprite";
      flake = false;
    };
    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };
    yazi-starship = {
      url = "github:Rolv-Apneseth/starship.yazi";
      flake = false;
    };
    yazi-mediainfo = {
      url = "github:boydaihungst/mediainfo.yazi";
      flake = false;
    };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    lib = import ./lib.nix inputs;
    pkgs = lib.mkPkgs {inherit system;};
  in {
    homeConfigurations = lib.mkUsr {
      inherit pkgs;
      modules = lib.scanPath {path = ./home;};
    };

    nixosConfigurations = {
      deskmini = lib.mkSys {
        hostname = "deskmini";
        inherit pkgs;
        modules = [./hosts/deskmini/hardware-configuration.nix] ++ (lib.scanPath {path = ./system;});
      };
      wsl = lib.mkSys {
        hostname = "wsl";
        inherit pkgs;
        modules = [./hosts/wsl/system.nix];
        hm-modules = [./hosts/wsl/home.nix];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        hello
      ];
    };
  };
}
