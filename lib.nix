inputs: let
  toml-config = builtins.fromTOML (builtins.readFile ./config.toml);
  username = toml-config.user.name;
  email = toml-config.user.email;
  monoNixosModules = [
    {
      mono.username = username;
      user = {
        hashedPassword = toml-config.user.password;
        extraGroups = toml-config.user.groups;
      };
      users = {
        mutableUsers = false;
        extraUsers.root.initialHashedPassword = "!";
      };
    }
    (rootPath + /modules/mono.nix)
  ];
  monoHomeModules = [
    {
      mono.username = username;
      mono.email = email;
    }
    (rootPath + /modules/mono.hm.nix)
  ];
  rootPath = ./.;
in {
  mkPkgs = {
    system,
    overlays ? [],
  }:
    import inputs.nixpkgs {
      inherit system;
      config.segger-jlink.acceptLicense = builtins.elem "segger-jlink" (toml-config.pkgs.unfree);
      config.dyalog.acceptLicense = builtins.elem "dyalog" (toml-config.pkgs.unfree);
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
      specialArgs = {inherit inputs rootPath;};
      modules =
        [
          {
            nixpkgs.pkgs = pkgs;
            networking.hostName = "${hostname}";
            # TODO: move to mono
            user.shell = pkgs.fish;
          }
        ]
        ++ (
          if (hm-modules == null)
          then []
          else [
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {inherit inputs rootPath;};
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              user-hm.imports = monoHomeModules ++ hm-modules;
            }
          ]
        )
        ++ monoNixosModules ++ modules;
    };

  mkUsr = {
    pkgs,
    modules,
  }: {
    "${username}" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs rootPath;};
      modules = monoHomeModules ++ modules;
    };
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
