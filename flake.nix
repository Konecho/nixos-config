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
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
    my-nixpkgs.url = "github:Konecho/my-nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs"; # follow ghc
    };
  };

  outputs = inputs @ {
    self,
    # nixpkgs,
    # nixos-hardware,
    # home-manager,
    # impermanence,
    # nix-doom-emacs,
    # nur,
    # my-nixpkgs,
    # hyprland,
    ...
  }: let
    system = "x86_64-linux";
    username = "mei";
    hostname = "deskmini";

    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (inputs.nixpkgs.lib.getName pkg) [
          # "corefonts" # onlyoffice
          # "android-studio-stable"
          "microsoft-edge-stable"
          # "vscode"
          "wechat-uos"
          "obsidian"
          "unrar"
          "libsciter" # rustdesk
          # "steam-runtime"
          # "steam-original"
          # "steam"
          # "steam-run"
          # "steamcmd"
        ];
      config.permittedInsecurePackages = [
        "electron-19.0.7"
        "electron-12.2.3"
        "openssl-1.1.1u"
      ];
      overlays = [
        (self: super: rec {
          mypkgs = inputs.my-nixpkgs.packages."${system}";
          # pokemonsay = super.pokemonsay.override {cowsay = super.neo-cowsay;};
          # winfonts = nur.repos.vanilla.Win10_LTSC_2019_fonts;
        })
        inputs.nur.overlay
      ];
    };
    remoteNixpkgsPatches = [
      {
        meta.description = "virtualbox: 7.0.6 -> 7.0.8; fix kernel 6.3 module";
        url = "https://github.com/NixOS/nixpkgs/pull/232770.diff";
        sha256 = "sha256-NzJ/kvfzueIfIZdq/Z9vIk0/x516Q36t35QRhFSKbas=";
      }
    ];
    originPkgs = inputs.nixpkgs.legacyPackages."${system}";
    nixpkgs = originPkgs.applyPatches {
      name = "nixpkgs-patched";
      src = inputs.nixpkgs;
      patches = map originPkgs.fetchpatch remoteNixpkgsPatches;
    };
    # nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
    # Uncomment to use a Nixpkgs without remoteNixpkgsPatches
    nixosSystem = inputs.nixpkgs.lib.nixosSystem;
  in {
    homeConfigurations."${username}" = inputs.home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs;
      modules = [
        inputs.hyprland.homeManagerModules.default
        inputs.nix-doom-emacs.hmModule
        inputs.stylix.homeManagerModules.stylix
        {
          home.username = "${username}";
          nix.registry.nixpkgs.flake = inputs.nixpkgs;
          imports = [./home];
        }
        # impermanence.nixosModules.home-manager.impermanence
        # {
        #   home.persistence."/nix/persist/home/${username}" = {
        #     directories = [
        #       "downloads"
        #       "media"
        #       ".ssh"
        #       ".vscode"
        #       ".config/Code"
        #     ];
        #     files = [
        #       ".bash_history"
        #       ".python_history"
        #     ];
        #     allowOther = true;
        #   };
        # }
      ];
    };

    nixosConfigurations."${hostname}" =
      # inputs.nixpkgs.lib.nixosSystem
      nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          {
            # nixpkgs.config.allowUnfreePredicate = pkg:
            #   builtins.elem (inputs.nixpkgs.lib.getName pkg) [
            #     "corefonts" # onlyoffice
            #   ];
            imports = [
              ./system
              (inputs.nixpkgs + "/nixos/modules/programs/wayland/wayland-session.nix")
            ];
            # nix.registry.nixpkgs.flake = inputs.nixpkgs;
            nixpkgs.overlays = [
              (self: super: rec {
                mypkgs = inputs.my-nixpkgs.packages."${system}";
              })
            ];
            networking.hostName = "${hostname}";
            # users.users.root.initialPassword = "admin";
            users.users."${username}" = {
              isNormalUser = true;
              initialPassword = "5112";
              shell = pkgs.fish;
              extraGroups = ["wheel" "adbusers" "input" "networkmanager" "video" "docker" "vboxusers"];
            };
          }
          inputs.impermanence.nixosModules.impermanence
          {
            environment.persistence."/persist" = {
              directories = [
                "/home/mei"
                "/etc/nixos"
                "/etc/NetworkManager/system-connections"
                "/var/log"
                "/var/lib"
              ];
              files = [
                "/etc/machine-id"
                # "/etc/passwd"
                # "/etc/shadow"
              ];
            };
          }
        ];
      };
  };
}
