{
  lib,
  inputs,
  ...
}: {
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
      # "https://devenv.cachix.org"
      # "https://konecho.cachix.org"
      "https://attic.xuyh0120.win/lantian"
      "https://cache.nixos.org/"
      # "https://cache.garnix.io"
    ]
    ++ inputs.my-nixpkgs.nixConfig.extra-substituters;
  nix.settings.trusted-public-keys =
    [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      # "konecho.cachix.org-1:WdZC2zag05oLTaBVQ9X8dI3dw5Lso7DqGRI92hTg+Mc="
      # "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ]
    ++ inputs.my-nixpkgs.nixConfig.extra-trusted-public-keys;
  system.stateVersion = lib.mkDefault "22.11";
}
