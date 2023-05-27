{
  # sudo nixos-rebuild switch
  description = "A flake";

  inputs = {
    # flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
    my-nixpkgs.url = "github:Konecho/my-nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    inputs @{ self
    , nixpkgs
    , nixos-hardware
    , home-manager
    , impermanence
    , nix-doom-emacs
    , nur
    , my-nixpkgs
    , hyprland
    , ...
    }:
    let
      system = "x86_64-linux";
      username = "mei";
      hostname = "deskmini";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "android-studio-stable"
          "microsoft-edge-stable"
          "vscode"
          # "obsidian"
          "unrar"
          "libsciter" # rustdesk
          "steam-runtime"
          "steam-original"
          "steam"
          "steam-run"
          "steamcmd"
        ];
        overlays = [
          (self: super: rec {
            mypkgs = my-nixpkgs.packages."${system}";
            cowsay = super.neo-cowsay;
            # winfonts = nur.repos.vanilla.Win10_LTSC_2019_fonts;
          })
          nur.overlay
        ];
      };

    in
    {
      homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration rec {
        inherit pkgs;
        modules = [
          hyprland.homeManagerModules.default
          nix-doom-emacs.hmModule
          {
            home.username = "${username}";
            # home.homeDirectory = "/home/${username}";
            imports = [ ./home ];
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

      nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem
        {
          modules = [
            ./hardware-configuration.nix
            {
              imports = [ ./system ];
              nixpkgs.overlays = [
                (self: super: rec {
                  mypkgs = my-nixpkgs.packages."${system}";
                })
              ];
              networking.hostName = "${hostname}";
              # users.users.root.initialPassword = "admin";
              users.users."${username}" = {
                isNormalUser = true;
                initialPassword = "5112";
                shell = pkgs.fish;
                extraGroups = [ "wheel" "adbusers" "input" "networkmanager" "video" "docker" ];
              };
            }
            impermanence.nixosModules.impermanence
            {
              environment.persistence."/persist" = {
                directories = [
                  "/home"
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
