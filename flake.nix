{
  # sudo nixos-rebuild switch
  description = "A flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nur.url = "github:nix-community/NUR";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @{ self, nixpkgs, nixos-hardware, home-manager, impermanence, nix-doom-emacs, hyprland, nur, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
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
      };
      username = "mei";
      hostname = "deskmini";
    in
    {
      homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration rec {
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
      };
      nixosConfigurations = {
        "${hostname}" = nixpkgs.lib.nixosSystem {
          modules = [
            ./hardware-configuration.nix
            {
              imports = [ ./system ];
              networking.hostName = "${hostname}";
              # users.users.root.initialPassword = "admin";
              users.users."${username}" = {
                isNormalUser = true;
                initialPassword = "5112";
                extraGroups = [ "wheel" "adbusers" "input" "networkmanager" ];
              };
            }
            impermanence.nixosModules.impermanence
            {
              environment.persistence."/persist" = {
                directories = [
                  "/home"
                  "/etc/nixos"
                  # "/etc/passwd"
                  # "/etc/shadow"
                  "/var/log"
                  "/var/lib/bluetooth"
                  "/var/lib/systemd/coredump"
                  "/etc/NetworkManager/system-connections"
                ];
                files = [ "/etc/machine-id" ];
              };
            }
          ];
        };
      };
    };
}
