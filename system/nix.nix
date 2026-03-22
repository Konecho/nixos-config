{
  lib,
  inputs,
  ...
}: {
  imports = [inputs.nixos-cli.nixosModules.nixos-cli];
  programs.nixos-cli = {
    enable = true;
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
  };
  nix.settings.substituters =
    [
      "https://mirrors.ustc.edu.cn/nix-channels/store/"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store "
      "https://cache.nixos.org/"
      # "https://devenv.cachix.org"
      # "https://cache.garnix.io"
      "https://watersucks.cachix.org" # nixos-cli
    ]
    ++ inputs.my-nixpkgs.nixConfig.extra-substituters;
  nix.settings.trusted-public-keys =
    [
      # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
    ]
    ++ inputs.my-nixpkgs.nixConfig.extra-trusted-public-keys;
  system.stateVersion = lib.mkDefault "22.11";
}
