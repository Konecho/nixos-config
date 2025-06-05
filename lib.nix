inputs: let
  toml-config = builtins.fromTOML (builtins.readFile ./config.toml);
  rootPath = ./.;
in {
  mkPkgs = {
    system,
    overlays ? [],
  }:
    import inputs.nixpkgs {
      inherit system;
      config.segger-jlink.acceptLicense = builtins.elem "segger-jlink" (toml-config.pkgs.unfree);
      config.allowUnfreePredicate = pkg:
        builtins.elem (inputs.nixpkgs.lib.getName pkg) (toml-config.pkgs.unfree);
      config.permittedInsecurePackages = toml-config.pkgs.insecure;
      overlays =
        [
          (self: super: rec {
            mypkgs = inputs.my-nixpkgs.packages."${system}";
            # winfonts = nur.repos.vanilla.Win10_LTSC_2019_fonts;
          })
          inputs.nur.overlays.default
        ]
        ++ overlays;
    };

  mkSys = {
    hostname,
    username,
    pkgs,
    system,
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
      specialArgs = {inherit inputs username system rootPath;};
      modules =
        [
          {
            nixpkgs.pkgs = pkgs;
            networking.hostName = "${hostname}";

            users = {
              users."${username}" = {
                isNormalUser = true;
                createHome = true;
                home = "/home";
                # mkpasswd -m sha-512
                hashedPassword = "$6$uiElHlBCyxUEkWFo$FqTxpsOFPhU0ak3V9.xGTvHblsRxQOffE6zfUGJMflt9B.11NqiokVB.yETtBU0hJn5Z.SNS6IFrlUj6hToAO/";
                shell = pkgs.fish;
                extraGroups = ["wheel" "adbusers" "input" "networkmanager" "video" "docker" "vboxusers" "plugdev"];
              };
              mutableUsers = false;

              extraUsers = {
                root = {
                  initialHashedPassword = "!";
                  # hashedPassword = "!";
                };
              };
            };
          }
        ]
        ++ (
          if (hm-modules != null)
          then [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {inherit inputs rootPath;};
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = {
                imports = hm-modules;
              };
              home-manager.backupFileExtension = "bak";
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
      extraSpecialArgs = {inherit inputs rootPath username;};
      modules =
        [
          {
            home.username = "${username}";
            nix.registry.nixpkgs.flake = inputs.nixpkgs;
          }
        ]
        ++ modules;
    };
  scanPath = {
    path,
    excludeFiles ? [],
  }:
    builtins.map
    (f: (path + "/${f}"))
    (builtins.attrNames
      (inputs.nixpkgs.lib.attrsets.filterAttrs
        (
          path: _type:
            !(builtins.elem path (["default.nix"] ++ excludeFiles)) # ignore default.nix
            && (
              (_type == "directory") # include directories
              || (inputs.nixpkgs.lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        )
        (builtins.readDir path)));
}
