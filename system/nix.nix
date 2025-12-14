{
  lib,
  inputs,
  config,
  ...
}: {
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    trusted-users = root ${config.mono.username}
  '';
  nix.settings.substituters =
    [
      "https://mirrors.ustc.edu.cn/nix-channels/store/"
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirror.sjtu.edu.cn/nix-channels/store "
      # "https://devenv.cachix.org"
      # "https://konecho.cachix.org"
      "https://cache.nixos.org/"
      "https://cache.garnix.io"
    ]
    ++ inputs.my-nixpkgs.nixConfig.extra-substituters;
  nix.settings.trusted-public-keys =
    [
      # "konecho.cachix.org-1:WdZC2zag05oLTaBVQ9X8dI3dw5Lso7DqGRI92hTg+Mc="
      # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ]
    ++ inputs.my-nixpkgs.nixConfig.extra-trusted-public-keys;
  system.stateVersion = lib.mkDefault "22.11";
}
