inputs: let
  toml-config = builtins.fromTOML (builtins.readFile ./config.toml);
in {
  mkPkgs = {system}:
    import inputs.nixpkgs {
      inherit system;
      config.segger-jlink.acceptLicense = builtins.elem "segger-jlink" (toml-config.pkgs.unfree);
      config.allowUnfreePredicate = pkg:
        builtins.elem (inputs.nixpkgs.lib.getName pkg) (toml-config.pkgs.unfree);
      config.permittedInsecurePackages = toml-config.pkgs.insecure;
      overlays = [
        (self: super: rec {
          mypkgs = inputs.my-nixpkgs.packages."${system}";
          # pokemonsay = super.pokemonsay.override {cowsay = super.neo-cowsay;};
          # winfonts = nur.repos.vanilla.Win10_LTSC_2019_fonts;
          # gnome = inputs.gnomeNixpkgs.legacyPackages.x86_64-linux.gnome;
        })
        inputs.nur.overlay
        # inputs.joshuto.overlays.default
      ];
    };

  mkSys = {
    hostname,
    username,
    pkgs,
    modules,
    hm-modules ? null,
  }: let
    # remoteNixpkgsPatches = [
    #   {
    #     meta.description = "virtualbox: 7.0.6 -> 7.0.8; fix kernel 6.3 module";
    #     url = "https://github.com/NixOS/nixpkgs/pull/232770.diff";
    #     sha256 = "sha256-NzJ/kvfzueIfIZdq/Z9vIk0/x516Q36t35QRhFSKbas=";
    #   }
    # ];
    # originPkgs = inputs.nixpkgs.legacyPackages."${system}";
    # nixpkgs = originPkgs.applyPatches {
    #   name = "nixpkgs-patched";
    #   src = inputs.nixpkgs;
    #   patches = map originPkgs.fetchpatch remoteNixpkgsPatches;
    # };
    # nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
    # Uncomment to use a Nixpkgs without remoteNixpkgsPatches
    nixosSystem = inputs.nixpkgs.lib.nixosSystem;
  in
    nixosSystem {
      specialArgs = {inherit inputs username;};
      modules =
        [
          {
            nixpkgs.pkgs = pkgs;
            networking.hostName = "${hostname}";
            users.users."${username}" = {
              isNormalUser = true;
              initialPassword = "5112";
              shell = pkgs.fish;
              extraGroups = ["wheel" "adbusers" "input" "networkmanager" "video" "docker" "vboxusers"];
            };
          }
        ]
        ++ (
          if (hm-modules != null)
          then [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {inherit inputs;};
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                home.stateVersion = "23.05";
                imports = hm-modules;
              };
            }
          ]
          else []
        )
        ++ modules;
    };

  mkUsr = {
    username,
    pkgs,
    modules,
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules =
        [
          # inputs.hyprland.homeManagerModules.default
          # inputs.nix-doom-emacs.hmModule
          # inputs.stylix.homeManagerModules.stylix
          {
            home.username = "${username}";
            nix.registry.nixpkgs.flake = inputs.nixpkgs;
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
        ]
        ++ modules;
    };
}
