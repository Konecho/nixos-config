inputs: let
  toml-config = fromTOML (builtins.readFile ./config.toml);
  username = toml-config.user.name;
  email = toml-config.user.email;
  monoNixosModules = [
    ./modules/mono.nix
    {
      mono.username = username;
      user = {
        hashedPassword = toml-config.user.password;
        extraGroups = toml-config.user.groups;
      };
    }
  ];
  monoHomeModules = [
    ./modules/mono.hm.nix
    {
      mono.username = username;
      mono.email = email;
    }
  ];
  homeModulesToNixosModules = hm-modules: [
    inputs.home-manager.nixosModules.home-manager
    ./modules/alias-hm.nix
    {
      home-manager.extraSpecialArgs = {inherit inputs rootPath;};
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      user-hm.imports = hm-modules;
    }
  ];
  rootPath = ./.;
in {
  mkPkgs = {
    system,
    overlays ? [],
  }:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (inputs.nixpkgs.lib.getName pkg) toml-config.pkgs.unfree;
      config.permittedInsecurePackages = toml-config.pkgs.insecure;
      overlays =
        [
          (self: super: {
            mypkgs = inputs.my-nixpkgs.packages."${system}";
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
            networking.hostName = hostname;
          }
        ]
        ++ (
          if (hm-modules != null)
          then (homeModulesToNixosModules (monoHomeModules ++ hm-modules))
          else []
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
    _path,
    excludeFiles ? [],
  }: let
    entries = builtins.readDir _path;
    names = builtins.attrNames entries;

    hasSuffix = suffix: str: let
      lenS = builtins.stringLength suffix;
      len = builtins.stringLength str;
    in
      (len > lenS)
      && builtins.substring (len - lenS) lenS str == suffix;

    valid = name: let
      type = entries.${name};
    in
      !(builtins.elem name (["default.nix"] ++ excludeFiles))
      && (
        (type == "directory")
        || (type == "regular" && hasSuffix ".nix" name)
      );
  in
    map
    (name: _path + "/${name}")
    (builtins.filter valid names);
}
